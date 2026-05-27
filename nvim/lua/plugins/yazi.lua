local ok, yazi = pcall(require, "yazi")
if not ok then
    vim.notify("yazi.nvim is not installed yet. Run :PackUpdate.", vim.log.levels.WARN, { title = "yazi.nvim" })
    return
end

yazi.setup({
    open_for_directories = false,
    yazi_floating_window_border = "rounded",
    keymaps = {
        show_help = "<f1>",
        grep_in_directory = false,
        replace_in_directory = false,
    },
})

vim.keymap.set({ "n", "v" }, "<leader>y", function()
    yazi.toggle()
end, { desc = "Open Yazi at current file" })

-- vim.keymap.set("n", "<leader>Y", "<cmd>Yazi cwd<CR>", { desc = "Open Yazi in cwd" })
-- 
-- vim.keymap.set("n", "<leader>yr", function()
--     yazi.toggle()
-- end, { desc = "Resume Yazi" })
