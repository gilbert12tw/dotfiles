local M = {}

local preview_dir = vim.fn.stdpath("cache") .. "/markdown-preview"

local function buffer_title()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return "markdown-preview"
    end

    return vim.fn.fnamemodify(name, ":t:r")
end

local function markdown_snapshot()
    vim.fn.mkdir(preview_dir, "p")

    local name = buffer_title():gsub("[^%w%._%-]", "-")
    local markdown_file = ("%s/%s-%d.md"):format(preview_dir, name, vim.api.nvim_get_current_buf())

    vim.fn.writefile(vim.api.nvim_buf_get_lines(0, 0, -1, false), markdown_file)

    return markdown_file
end

function M.glow()
    Snacks.terminal({ "glow", "-w", "100", "-p", markdown_snapshot() }, {
        auto_close = true,
        interactive = true,
        win = {
            border = "rounded",
            height = 0.9,
            title = " Glow Markdown ",
            width = 0.9,
        },
    })
end

vim.api.nvim_create_user_command("MarkdownGlow", M.glow, { desc = "Preview markdown with glow" })

vim.keymap.set("n", "<leader>mg", M.glow, { desc = "Markdown Glow Preview" })

return M
