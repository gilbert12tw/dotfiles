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
})

require("colorscheme")
require("plugins.harpoon")
require("plugins.aerial")

-- mini files ----
local MiniFiles = require("mini.files")
MiniFiles.setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })

---- mini notify ----
require("mini.notify").setup({
    -- only show messages
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

--- mini cmdline completion ---
require("mini.cmdline").setup({
    autocorrect = { enable = false }
})

--- mini surround ---
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sh` | Highlight surrounding |

--- mini picker ---
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")

local mini_pick_window = function()
    local max_width = math.max(20, vim.o.columns - 8)
    local max_height = math.max(8, vim.o.lines - 6)

    local width = math.min(math.max(60, math.floor(0.70 * vim.o.columns)), max_width)
    local height = math.min(math.max(12, math.floor(0.65 * vim.o.lines)), max_height)

    return {
        anchor = "NW",
        border = "rounded",
        col = math.floor(0.5 * (vim.o.columns - width)),
        height = height,
        row = math.floor(0.5 * (vim.o.lines - height)),
        width = width,
    }
end

MiniPick.setup({
    window = {
        config = mini_pick_window,
        prompt_caret = "_",
        prompt_prefix = "Search: ",
    },
})
MiniExtra.setup()

local mocha = require("catppuccin.palettes").get_palette("mocha")
vim.api.nvim_set_hl(0, "MiniPickBorder", { fg = mocha.mauve, bg = mocha.mantle })
vim.api.nvim_set_hl(0, "MiniPickBorderBusy", { fg = mocha.peach, bg = mocha.mantle })
vim.api.nvim_set_hl(0, "MiniPickBorderText", { fg = mocha.lavender, bg = mocha.mantle, bold = true })
vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { fg = mocha.text, bg = mocha.surface0, bold = true })
vim.api.nvim_set_hl(0, "MiniPickMatchRanges", { fg = mocha.yellow, bold = true })
vim.api.nvim_set_hl(0, "MiniPickNormal", { fg = mocha.text, bg = mocha.mantle })
vim.api.nvim_set_hl(0, "MiniPickPrompt", { fg = mocha.sky, bg = mocha.mantle })
vim.api.nvim_set_hl(0, "MiniPickPromptCaret", { fg = mocha.peach, bg = mocha.mantle, bold = true })
vim.api.nvim_set_hl(0, "MiniPickPromptPrefix", { fg = mocha.mauve, bg = mocha.mantle, bold = true })

-- keymaps
vim.keymap.set("n", "<C-p>", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>fw", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
    { desc = "Grep word/Search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>fk", function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })

--- mini completions ---
local MiniCompletion = require("mini.completion")

MiniCompletion.setup({
    lsp_completion = {
        auto_setup = true,
        process_items = function(items, base)
            return MiniCompletion.default_process_items(items, base, {
                filtersort = "fuzzy",
            })
        end,
    }
})

--- mini snippets ---
local MiniSnippets = require("mini.snippets")

MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets automatically
    },
})
MiniSnippets.start_lsp_server({ match = false })

--- mini diff & fugitive ---
local MiniDiff = require("mini.diff")
MiniDiff.setup({
    source = MiniDiff.gen_source.git({ index = false }),
})
-- gh : stage hunk
-- gH : reset hunk
-- ]h : next hunk
-- [h : prev hunk

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split", })


--- nvim treesitter ---
require("treesitter")

--- lsp ---
require("lsp")
