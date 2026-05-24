vim.pack.add({
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/stevearc/aerial.nvim",
    { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/toppair/peek.nvim",
})

require("colorscheme")
require("plugins.snacks")
require("plugins.harpoon")
require("plugins.aerial")
require("plugins.mini")
require("plugins.markdown")
require("plugins.peek")

--- nvim treesitter ---
require("treesitter")

--- lsp ---
require("lsp")
