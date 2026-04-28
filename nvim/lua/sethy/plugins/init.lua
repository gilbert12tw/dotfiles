return {
    "nvim-lua/plenary.nvim", -- functions multiple plugins need
    -- fixes the well know nvim bug
    {
        "folke/lazydev.nvim",
        lazy = "VeryLazy",
        priority = 1000,
        opts = {
            library = {
                {
                    path = "${3rd}/plenary.nvim/lua",
                    words = { "plenary" }
                },
                { path = "LazyVim" },
            },
        },
    },
}
