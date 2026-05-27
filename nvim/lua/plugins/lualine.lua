local ok, lualine = pcall(require, "lualine")
if not ok then
    vim.notify("lualine.nvim is not installed yet. Run :PackUpdate.", vim.log.levels.WARN, { title = "lualine" })
    return
end

lualine.setup({
    options = {
        theme = "auto",
        globalstatus = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
        disabled_filetypes = {
            statusline = {
                "minifiles",
                "snacks_dashboard",
                "snacks_picker",
            },
        },
    },
    sections = {
        lualine_x = {
            { "encoding" },
            { "fileformat" },
            { "filetype" },
        },
    },
})

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("GilbertLualineThemeSync", { clear = true }),
    callback = function()
        lualine.refresh()
    end,
})
