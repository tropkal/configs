#!/usr/bin/bash

# do-release-upgrade to go from 20.04 to 22.04 for example
# not being on 22.04 lts will not be able to install the proper nvim version
# to be able to do this, we need to have `bc` installed, so installing that 1st
echo "[!] Making sure we have bc installed first"
sudo apt update > /dev/null 2>&1 && sudo apt install bc -y > /dev/null 2>&1 

result=`lsb_release -r  | awk -F\  '{print $2}'`
if (( $(echo "$result == 22.04" | bc -l) )); then
    echo "[+] Your installed version of Ubuntu is 22.04 which is good, continuing..."
else echo "[!] You need Ubuntu 22.04 for this script to work properly, do you want to upgrade to it?"
    read -p echo "WARNING!! This will upgrade your distro to Ubuntu 22.04 LTS, ARE YOU SURE?" answer
    if [[ $answer == "y" ]]; then
        echo "[!] You will probably need to re-run this script after installing 22.04"
        read -p "[!] Upgrading to Ubuntu 22.04 LTS. This is gonna take a while!" answer
        echo "DUDE, ARE YOU REALLY SURE?"
        if [[ $answer == "y" ]]; then
            sudo do-release-upgrade
        fi
    fi
fi

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

which npm > /dev/null
if [ $? -ne 0 ]; then echo "[!] npm isn't installed"; array+=("npm"); else echo "[+] npm is installed in $(which npm)"; fi

# the array contains items which aren't installed
for item in "${array[@]}"; do
    read -p "Want to install $item ? [y/n] " answer

    if [[ $answer == "y" ]]; then 
        if [[ $item == "zsh" ]]; then
            sudo apt-get update > /dev/null && sudo apt-get install zsh -y > /dev/null && \
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null
        elif [[ $item == "nvim" ]]; then
            # 1st install `software-properties-common` to be able to use `add-apt-repository`
            # also install `python3-venv`, required for `pylsp` in Mason
            # also install `golang-1.21`, required for `gopls` in Mason
            sudo apt-get install golang-1.21 -y > /dev/null && \
            sudo apt-get install python3-venv -y > /dev/null && \
            sudo apt-get install software-properties-common -y > /dev/null && \
            # install python3-launchpadlib so the add-apt-repository cmd doesnt fail
            sudo apt-get install python3-launchpadlib -y > /dev/null && \
            # add the neovim-ppa/unstable repo and install neovim
            sudo add-apt-repository ppa:neovim-ppa/unstable > /dev/null && \
            sudo apt-get update > /dev/null && \
            sudo apt-get install neovim -y > /dev/null;
        elif [[ $item == "i3" ]]; then
            installed_i3=true
        else
            installed_i3=false
            sudo apt update > /dev/null && sudo apt install $item -y > /dev/null;
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

if [ -d ~/.config/i3 ] && installed_i3=true; then
    cp i3/config ~/.config/i3/config && cp i3/desktop_wallpaper.jpg /opt/desktop_wallpaper.jpg
fi

mkdir ~/.config/nvim/ && cp -r nvim/ ~/.config/nvim/

# copy the `robbyrussell_modified` zsh theme
echo "[!] Copying the zsh theme"
cp oh-my-zsh/themes/robbyrussell_modified.zsh-theme ~/.oh-my-zsh/themes/

# copy the chatgpt scripts, install openai using pip and install pip if its not already installed 
# dont forget to manually copy your chatgpt api key
echo "[!] Checking if pip is installed and if not, install it"
which pip > /dev/null
if [ $? -ne 0 ]; then echo "[+] Installing pip & openai" && sudo apt install python3-pip -y; fi
pip list | grep -i openai > /dev/null
if [ $? -ne 0 ]; then pip install openai > /dev/null; fi
echo "[!] Copying the chatgpt scripts"
cp chatgpt/howto* ~

# checking if the tmux plugin manager folder exists
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "[!] Installing the tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# install nvim plugins
echo "[!] Installing the packer plugin manager for nvim if it's not installed already"
if [ ! -d ~/.local/share/nvim/site/pack ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim > /dev/null
fi

echo "[!] Copy/make your own zshrc file!"
echo "[+] Done copying the configs, enjoy xD"
