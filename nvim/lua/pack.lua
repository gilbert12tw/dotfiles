vim.pack.add({
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/stevearc/aerial.nvim",
    { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/toppair/peek.nvim",
    "https://github.com/mikavilpas/yazi.nvim",
    "https://github.com/kawre/leetcode.nvim",
    "https://github.com/ThePrimeagen/vim-be-good",
})

require("colorscheme")
require("plugins.snacks")
require("plugins.lualine")
require("plugins.harpoon")
require("plugins.aerial")
require("plugins.mini")
require("plugins.markdown")
require("plugins.peek")
require("plugins.yazi")
require("plugins.leetcode")

--- nvim treesitter ---
require("treesitter")

--- lsp ---
require("lsp")
