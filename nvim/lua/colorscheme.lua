require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    styles = {
        comments = {},
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

local no_italic_groups = {
    "Comment",
    "@comment",
    "@comment.documentation",
}

for _, group in ipairs(no_italic_groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok and next(hl) ~= nil then
        hl.italic = false
        vim.api.nvim_set_hl(0, group, hl)
    end
end
