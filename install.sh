#!/usr/bin/bash

### Install tmux/nvim/i3 configs ###

# ask to backup existing configs before overwriting them, just in case

if [ -d ~/.config/tmux ]; then 
    if [ -f ~/.config/tmux/tmux.conf ]; then
        read -p "Want to backup ~/.config/tmux/tmux.conf ? [y/n] " answer
        if [[ $answer == "y" ]]; then mv ~/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf.bak; 
        fi
    fi
fi

if [ -f ~/.tmux.conf ]; then
    read -p "Want to backup ~/.tmux.conf ? [y/n] " answer
    if [[ $answer == "y" ]]; then mv ~/.tmux.conf ~/.tmux.conf.bak; 
    fi
fi

if [ -d ~/.config/i3 ]; then 
    if [ -f ~/.config/i3/config ]; then
        read -p "Want to backup ~/.config/i3/config ? [y/n] " answer
        if [[ $answer == "y" ]]; then mv ~/.config/i3/config ~/.config/i3/config.bak; 
        fi
    fi
fi

if [ -d ~/.config/nvim ]; then 
    read -p "Want to backup ~/.config/nvim ? [y/n] " answer
    if [[ $answer == "y" ]]; then mv ~/.config/nvim ~/.config/nvim.bak; 
    fi
fi

if [ -f ~/.zshrc ]; then 
    read -p "Want to backup ~/.zshrc ? [y/n] " answer
    if [[ $answer == "y" ]]; then mv ~/.zshrc ~/.zshrc.bak; 
    fi
fi

# check if tmux/nvim/i3/zsh is already installed and if not, ask to install
array=()

which tmux > /dev/null
if [ $? -ne 0 ]; then echo "[!] tmux isn't installed"; array+=("tmux"); else echo "[+] tmux is installed in $(which tmux)" ; fi

which i3 > /dev/null
if [ $? -ne 0 ]; then echo "[!] i3 isn't installed"; array+=("i3"); else echo "[+] i3 is installed in $(which i3)"; fi

which zsh > /dev/null
if [ $? -ne 0 ]; then echo "[!] zsh isn't installed"; array+=("zsh"); else echo "[+] zsh is installed in $(which zsh)"; fi

which nvim > /dev/null
if [ $? -ne 0 ]; then echo "[!] nvim isn't installed"; array+=("nvim"); else echo "[+] nvim is installed in $(which nvim)"; fi


# the array contains items which aren't installed
for item in "${array[@]}"; do
    read -p "Want to install $item ? [y/n] " answer

    if [[ $answer == "y" ]]; then 
        if [[ $item == "zsh" ]]; then
            sudo apt update && sudo apt install zsh -y && \
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        elif [[ $item == "nvim" ]]; then
            # 1st install `software-properties-common` to be able to use `add-apt-repository`
            sudo apt-get install software-properties-common -y && \
            # add the neovim-ppa/stable repo and install neovim
            sudo add-apt-repository ppa:neovim-ppa/stable && \
            sudo apt-get update && \
            sudo apt-get install neovim -y;
        else 
            sudo apt update && sudo apt install $item -y;
        fi
    fi
done

# Prerequisites for the Python modules; dont think I need this, found it on neovim's installing steps on github
# sudo apt-get install python-dev python-pip python3-dev python3-pip

# check if the directories exist under ~/.config, if not, create them & copy the configs

if [ -d ~/.config/tmux ]; then
    cp tmux/tmux.conf ~/.config/tmux/tmux.conf
else mkdir ~/.config/tmux && cp tmux/tmux.conf ~/.config/tmux/tmux.conf
fi

if [ -d ~/.config/i3 ]; then
    cp i3/config ~/.config/i3/config
else mkdir ~/.config/i3 && cp i3/config ~/.config/i3/config
fi

cp -r nvim/ ~/.config

# copy the `robbyrussell_modified` zsh theme
echo "[!] Copying the zsh theme"
cp oh-my-zsh/themes/robbyrussell_modified.zsh-theme ~/.oh-my-zsh/themes/

# copy the chatgpt scripts, install openai using pip and install pip if its not already installed 
# dont forget to manually copy your chatgpt api key
echo "[!] Checking if pip is installed and if not, install it"
which pip > /dev/null
if [ $? -ne 0 ]; then echo "[+] Installing pip & openai" && sudo apt install python3-pip -y; fi
pip install openai > /dev/null
echo "[!] Copying the chatgpt scripts"
cp chatgpt/howto* ~

echo "[!] Copy/make your own zshrc file!"
echo "[+] Done copying the configs, enjoy xD"
