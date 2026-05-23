local aerial = require("aerial")

aerial.setup({
    backends = { "treesitter", "lsp", "markdown", "man" },
    nerd_font = true,
    show_guides = true,
    layout = {
        default_direction = "prefer_right",
        max_width = { 40, 0.25 },
        min_width = 28,
        resize_to_content = false,
    },
    filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        "Package",
        "Property",
        "Struct",
        "Trait",
    },
    on_attach = function(bufnr)
        vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Previous symbol" })
        vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next symbol" })
    end,
})

vim.keymap.set("n", "<leader>t", "<cmd>AerialToggle!<CR>", { desc = "Toggle aerial outline" })
vim.keymap.set("n", "<leader>T", "<cmd>AerialNavToggle<CR>", { desc = "Toggle aerial nav" })
