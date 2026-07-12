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

local show_dotfiles = false
local filter_show = function(fs_entry) return true end
local filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, '.')
end
local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    MiniFiles.refresh({ content = { filter = new_filter } })
end
vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak left-hand side of mapping to your liking
        vim.keymap.set('n', '.', toggle_dotfiles, { buffer = buf_id })
    end,
    desc = "Toggle dotfile in minifile",
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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "snacks_picker_input",
    callback = function()
        vim.b.minicompletion_disable = true
    end,
    desc = "Disable mini.completion in Snacks picker input",
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'minifiles',
    callback = function()
        vim.b.minicompletion_disable = true
    end,
    desc = "Disable mini.completion in minifiles",
})

--- mini snippets ---
local MiniSnippets = require("mini.snippets")

MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets automatically
    },
})
if #vim.api.nvim_list_uis() > 0 then
    local snippets_lsp_ok, snippets_lsp_err = pcall(MiniSnippets.start_lsp_server, { match = false })
    if not snippets_lsp_ok then
        vim.schedule(function()
            vim.notify(snippets_lsp_err, vim.log.levels.WARN, { title = "mini.snippets" })
        end)
    end
end

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
