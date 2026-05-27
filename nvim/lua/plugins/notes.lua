local M = {}

local vaults = {
    note = "/Users/littlepants/Documents/Obsidian/Note",
    cp = "/Users/littlepants/Documents/Obsidian/Competitive_Programming",
}

local dirs = {
    quicknotes = vaults.note .. "/Quicknotes",
    daily = vaults.note .. "/Daily",
    cp_solutions = vaults.cp .. "/解題心得區",
}

vim.env.ZK_NOTEBOOK_DIR = vim.env.ZK_NOTEBOOK_DIR or vaults.note

local function notify_missing(name)
    vim.notify(name .. " is not installed yet. Run :PackUpdate.", vim.log.levels.WARN, { title = "notes" })
end

local function notebook_root()
    local ok, util = pcall(require, "zk.util")
    if not ok then
        return vaults.note
    end

    return util.notebook_root(vim.api.nvim_buf_get_name(0)) or vaults.note
end

local function is_zk_notebook_buffer(bufnr)
    local ok, util = pcall(require, "zk.util")
    if not ok then
        return false
    end

    return util.notebook_root(vim.api.nvim_buf_get_name(bufnr)) ~= nil
end

local function detach_marksman_from_notes(bufnr)
    if not is_zk_notebook_buffer(bufnr) then
        return
    end

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "marksman" })) do
        vim.lsp.buf_detach_client(bufnr, client.id)
    end
end

local function zk_cmd(name, opts)
    local ok, commands = pcall(require, "zk.commands")
    if not ok then
        notify_missing("zk.nvim")
        return
    end

    commands.get(name)(opts or {})
end

local function input_title(prompt, callback)
    vim.ui.input({ prompt = prompt }, function(title)
        if title == nil or title == "" then
            return
        end

        callback(title)
    end)
end

local function note_name(path)
    return vim.fn.fnamemodify(path, ":t:r")
end

local function edit_note(note)
    if note and note.absPath then
        vim.cmd.edit(vim.fn.fnameescape(note.absPath))
    end
end

local function pick_notes(opts)
    local ok_api, api = pcall(require, "zk.api")
    if not ok_api then
        notify_missing("zk.nvim")
        return
    end

    opts = opts or {}
    opts.select = { "title", "path", "absPath" }

    api.list(opts.notebook_path, opts, function(err, notes)
        if err then
            vim.schedule(function()
                vim.notify(tostring(err), vim.log.levels.ERROR, { title = "zk.nvim" })
            end)
            return
        end

        vim.schedule(function()
            Snacks.picker.pick("Zk Notes", {
                items = vim.tbl_map(function(note)
                    local name = note_name(note.absPath or note.path)
                    return {
                        text = name,
                        file = note.absPath,
                        value = note,
                        preview = { file = note.absPath },
                    }
                end, notes or {}),
                format = "text",
                layout = {
                    preset = "ivy",
                    layout = {
                        position = "bottom",
                    },
                },
                confirm = function(picker, item)
                    picker:close()
                    edit_note(item.value)
                end,
            })
        end)
    end)
end

local function setup_note_link_completion(bufnr)
    if not is_zk_notebook_buffer(bufnr) then
        return
    end

    vim.keymap.set("i", "[[", "[[<Cmd>lua vim.schedule(function() require('mini.completion').complete_twostage(false, true) end)<CR>", {
        buffer = bufnr,
        desc = "Complete note link",
    })
end

local zk_ok, zk = pcall(require, "zk")
if zk_ok then
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

    zk.setup({
        picker = "snacks_picker",
        picker_options = {
            snacks_picker = {
                layout = {
                    preset = "ivy",
                    layout = {
                        position = "bottom",
                    },
                },
            },
        },
        lsp = {
            config = {
                name = "zk",
                cmd = { "zk", "lsp" },
                filetypes = { "markdown" },
                capabilities = capabilities,
            },
            auto_attach = {
                enabled = true,
            },
        },
    })
else
    notify_missing("zk.nvim")
end

local obsidian_ok, obsidian = pcall(require, "obsidian")
if obsidian_ok then
    obsidian.setup({
        legacy_commands = false,
        workspaces = {
            {
                name = "note",
                path = vaults.note,
                overrides = {
                    notes_subdir = "Quicknotes",
                    new_notes_location = "notes_subdir",
                    daily_notes = {
                        enabled = true,
                        folder = "Daily",
                    },
                },
            },
            {
                name = "cp",
                path = vaults.cp,
                overrides = {
                    notes_subdir = "解題心得區",
                    new_notes_location = "notes_subdir",
                },
            },
        },
        notes_subdir = "Quicknotes",
        new_notes_location = "notes_subdir",
        daily_notes = {
            enabled = true,
            folder = "Daily",
            date_format = "YYYY-MM-DD",
            default_tags = { "daily" },
        },
        picker = {
            name = "snacks.picker",
        },
        completion = {
            nvim_cmp = false,
            blink = false,
        },
        link = {
            style = "wiki",
            format = "shortest",
        },
        attachments = {
            folder = "assets",
        },
        note_id_func = require("obsidian.builtin").title_id,
    })
else
    notify_missing("obsidian.nvim")
end

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Use zk instead of marksman inside note vaults",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "marksman" then
            vim.schedule(function()
                detach_marksman_from_notes(args.buf)
            end)
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    desc = "Keep marksman detached from note vault buffers",
    pattern = { "*.md", "markdown" },
    callback = function(args)
        vim.schedule(function()
            detach_marksman_from_notes(args.buf)
            setup_note_link_completion(args.buf)
        end)
    end,
})

vim.keymap.set("n", "<leader>nn", function()
    input_title("Note title: ", function(title)
        zk_cmd("ZkNew", {
            notebook_path = vaults.note,
            dir = dirs.quicknotes,
            title = title,
        })
    end)
end, { desc = "New quick note" })

vim.keymap.set("n", "<leader>nd", function()
    vim.cmd("Obsidian workspace note")
    vim.cmd("Obsidian today")
end, { desc = "Open daily note" })

vim.keymap.set("n", "<leader>nc", function()
    input_title("CP note title: ", function(title)
        zk_cmd("ZkNew", {
            notebook_path = vaults.cp,
            dir = dirs.cp_solutions,
            title = title,
        })
    end)
end, { desc = "New CP note" })

vim.keymap.set("n", "<leader>no", function()
    pick_notes({
        notebook_path = notebook_root(),
        sort = { "modified" },
    })
end, { desc = "Open notes" })

vim.keymap.set("n", "<leader>nf", function()
    vim.ui.input({ prompt = "Search notes: " }, function(query)
        if query == nil or query == "" then
            return
        end

        pick_notes({
            notebook_path = notebook_root(),
            sort = { "modified" },
            match = { query },
        })
    end)
end, { desc = "Search notes" })

vim.keymap.set("v", "<leader>nf", ":'<,'>ZkMatch<CR>", { desc = "Search selected note text" })

vim.keymap.set("n", "<leader>nt", function()
    zk_cmd("ZkTags", {
        notebook_path = notebook_root(),
    })
end, { desc = "Search note tags" })

vim.keymap.set("n", "<leader>nb", "<cmd>ZkBacklinks<CR>", { desc = "Note backlinks" })
vim.keymap.set("n", "<leader>nl", "<cmd>ZkLinks<CR>", { desc = "Note outbound links" })
vim.keymap.set("n", "<leader>ni", "<cmd>ZkIndex<CR>", { desc = "Index notes" })
vim.keymap.set("n", "<leader>nw", "<cmd>Obsidian workspace<CR>", { desc = "Switch Obsidian workspace" })
vim.keymap.set("n", "<leader>nO", "<cmd>Obsidian open<CR>", { desc = "Open note in Obsidian" })

return M
