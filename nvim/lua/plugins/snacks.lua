local function vimpack_startup()
    local ok, packs = pcall(vim.pack.get)
    local count = 0

    if ok then
        for _, pack in ipairs(packs) do
            if pack.active then
                count = count + 1
            end
        end
    end

    return {
        align = "center",
        text = {
            { "Neovim loaded ", hl = "footer" },
            { tostring(count), hl = "special" },
            { " active vim.pack plugins", hl = "footer" },
        },
    }
end

local function keymap_desc_format(item)
    local keymap = item.item

    return {
        { keymap.mode or "", "MyKeymapMode" },
        { "  " },
        { Snacks.util.normkey(keymap.lhs or ""), "MyKeymapLhs" },
        { "\t" },
        { keymap.desc or "", "MyKeymapDesc" },
    }
end

local function set_keymap_picker_hl()
    local mocha = require("catppuccin.palettes").get_palette("mocha")

    vim.api.nvim_set_hl(0, "MyKeymapMode", { fg = mocha.peach, bold = true })
    vim.api.nvim_set_hl(0, "MyKeymapLhs", { fg = mocha.mauve, bold = true })
    vim.api.nvim_set_hl(0, "MyKeymapDesc", { fg = mocha.sky })
end

require("snacks").setup({
    dashboard = {
        sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            vimpack_startup,
            {
                section = "terminal",
                cmd = "pokemon-colorscripts -r;",
                random = 10,
                pane = 2,
                indent = 8,
                height = 30,
                col = nil,
            },
        },
    },
    picker = {},
    notifier = {
        timeout = 3000,
        style = "compact",
    },
    terminal = {},
    quickfile = {},
    bigfile = {},
    zen = {
        win = {
            width = 100,
        },
    },
    indent = {
        indent = {
            char = "",
        },
        scope = {
            char = "¦",
        },
        animate = {
            enabled = true,
        },
    },
    gitbrowse = {
        what = "file",
    },
    lazygit = {},
})

vim.notify = Snacks.notifier.notify
set_keymap_picker_hl()

--- Zen ---
vim.keymap.set("n", "<leader>z", function()
    Snacks.zen()
end, { desc = "Toggle Zen Mode" })

vim.keymap.set("n", "<leader>Z", function()
    Snacks.zen.zoom()
end, { desc = "Toggle Zoom Mode" })

Snacks.toggle.indent():map("<leader>i", { desc = "Toggle Indent Guides" })

--- Git ---
vim.keymap.set("n", "<leader>gb", function()
    Snacks.git.blame_line()
end, { desc = "Git Blame Line" })

vim.keymap.set({ "n", "v" }, "<leader>gB", function()
    Snacks.gitbrowse()
end, { desc = "Git Browse" })

vim.keymap.set("n", "<leader>gl", function()
    Snacks.lazygit()
end, { desc = "Lazygit" })

vim.keymap.set("n", "<leader>gL", function()
    Snacks.lazygit.log()
end, { desc = "Lazygit Log" })

vim.keymap.set("n", "<leader>gf", function()
    Snacks.lazygit.log_file()
end, { desc = "Lazygit Current File Log" })

vim.keymap.set("n", "<leader>nh", function()
    Snacks.notifier.show_history()
end, { desc = "Notification History" })

--- Picker ---
vim.keymap.set("n", "<C-p>", function()
    Snacks.picker.files()
end, { desc = "Snacks File Picker" })

vim.keymap.set("n", "<leader>fw", function()
    Snacks.picker.grep({ need_search = true })
end, { desc = "Grep text" })

vim.keymap.set("n", "<leader>xx", function()
    Snacks.picker.diagnostics()
end, { desc = "Snacks Picker Diagnostics" })

vim.keymap.set("n", "<leader>vh", function()
    Snacks.picker.help({
        layout = {
            preset = "ivy",
            layout = {
                position = "bottom",
            },
        },
    })
end, { desc = "Snacks Help" })

vim.keymap.set("n", "<leader>fk", function()
    Snacks.picker.keymaps({
        format = keymap_desc_format,
        layout = "select",
    })
end, { desc = "Search keymaps" })
