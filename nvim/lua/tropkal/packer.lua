-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

-- this had a return before `require`, dk why
return require("packer").startup(function(use)
    -- Packer can manage itself
    -- this :packersync doesnt work, need to do it manually
    use { "wbthomason/packer.nvim", run = ':PackerSync' }

    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.4",
        -- or                            , branch = "0.1.x",
        requires = { {"nvim-lua/plenary.nvim"} }
    }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- Recommended, not required.

    use { "rose-pine/neovim", as = "rose-pine" } -- aura-theme, catppuccin, gruvbox dark hard (no packer supp?)
                                                 -- github dark default

    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use("nvim-treesitter/playground")
    use("theprimeagen/harpoon")
    use("mbbill/undotree")

    use {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v3.x",
      requires = {
        --- Uncomment these if you want to manage LSP servers from neovim
        {"williamboman/mason.nvim"},
        {"williamboman/mason-lspconfig.nvim"},

        -- LSP Support
        {"neovim/nvim-lspconfig"},
        -- Autocompletion
        {"hrsh7th/nvim-cmp"},
        {"hrsh7th/cmp-buffer"},
        {"hrsh7th/cmp-path"},
        {"saadparwaiz1/cmp_luasnip"},
        {"hrsh7th/cmp-nvim-lsp"},
        {"hrsh7th/cmp-nvim-lua"},
        {"L3MON4D3/LuaSnip"},
        {"rafamadriz/friendly-snippets"},
      }
    }

end)
