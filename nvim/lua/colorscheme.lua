require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    styles = {
        comments = {},
        conditionals = {},
        functions = {},
        keywords = {},
        loops = {},
        operators = {},
        properties = {},
        types = {},
        variables = {},
    },
    integrations = {
        mini = {
            enabled = true,
        },
    },
})

vim.cmd.colorscheme("catppuccin")

local transparent_groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "Pmenu",
    "SignColumn",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
}

for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
end

for group, hl in pairs(vim.api.nvim_get_hl(0, {})) do
    if hl.italic then
        hl.italic = false
        vim.api.nvim_set_hl(0, group, hl)
    end
end
