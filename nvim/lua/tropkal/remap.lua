vim.g.mapleader = " "

-- shortcut for the Ex mode
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- in visual mode, hightlight lines & move around, gets autoindented
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- moves the current line one line down, basically swapping 2 lines
vim.keymap.set("n", "<leader>w", ":m .+1<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- search terms stay in the middle of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- yank line, hightlight where you wanna paste over (replace) & the yanked line is preserved
vim.keymap.set("x", "<leader>p", "\"_dP")

-- <leader>y copies to the system clipboard, <leader>Y copies only within vim
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Quickfix list navigation, gotta learn how to use this first lul
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- %s on the word you want to replace and replace it with the new thing
-- global
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
-- single line, make it work mb?

-- executes chmod +x <file>
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- executes the script 
vim.keymap.set("n", "<leader>r", "<cmd>!./%<CR>")
vim.keymap.set("n", "<leader>R", "<cmd>!%<CR>")
vim.keymap.set("n", "<leader>gr", "<cmd>!go run %<CR>")
vim.keymap.set("n", "<leader>cr", "<cmd>!cargo run %<CR>")

-- switch between 2 vim buffers
vim.keymap.set("n", "<leader>z", "<C-6>")

-- remap the arrows keys for insert mode to holding ALT + h,j,k,l
vim.api.nvim_set_keymap('i', '<A-h>', '<Left>', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Down>', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Up>'  , { noremap = true })
vim.api.nvim_set_keymap('i', '<A-l>', '<Right>', { noremap = true })
