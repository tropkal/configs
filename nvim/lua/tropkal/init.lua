require("tropkal.remap")
require("tropkal.set")

vim.cmd('autocmd BufWritePre * :normal gg=G``')
