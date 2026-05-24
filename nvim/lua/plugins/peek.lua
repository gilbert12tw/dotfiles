local ok, peek = pcall(require, "peek")
if not ok then
    vim.notify("peek.nvim is not installed yet. Run :PackUpdate, then :PeekBuild.", vim.log.levels.WARN, {
        title = "peek.nvim",
    })
    return
end

local deno_bin = vim.fn.expand("~/.deno/bin")
if vim.fn.executable("deno") ~= 1 and vim.fn.executable(deno_bin .. "/deno") == 1 then
    vim.env.PATH = deno_bin .. ":" .. vim.env.PATH
end

peek.setup({
    app = "browser",
    auto_load = true,
    close_on_bdelete = true,
    filetype = { "markdown" },
    syntax = true,
    theme = "dark",
    update_on_change = true,
})

local function plugin_path()
    local info = debug.getinfo(peek.open, "S")
    local source = info and info.source or ""
    if not source:match("^@") then
        return nil
    end

    return vim.fs.dirname(vim.fs.dirname(source:sub(2)))
end

vim.api.nvim_create_user_command("PeekOpen", peek.open, { desc = "Open Peek markdown preview" })
vim.api.nvim_create_user_command("PeekClose", peek.close, { desc = "Close Peek markdown preview" })
vim.api.nvim_create_user_command("PeekToggle", function()
    if peek.is_open() then
        peek.close()
    else
        peek.open()
    end
end, { desc = "Toggle Peek markdown preview" })

vim.api.nvim_create_user_command("PeekBuild", function()
    local root = plugin_path()
    if not root then
        vim.notify("Could not locate peek.nvim plugin directory", vim.log.levels.ERROR, { title = "peek.nvim" })
        return
    end

    local deno = vim.fn.executable("deno") == 1 and "deno" or vim.fn.expand("~/.deno/bin/deno")
    if vim.fn.executable(deno) ~= 1 then
        vim.notify("Deno not found. Add deno to PATH or install it first.", vim.log.levels.ERROR, { title = "peek.nvim" })
        return
    end

    vim.notify("Building peek.nvim...", vim.log.levels.INFO, { title = "peek.nvim" })
    vim.system({ deno, "task", "--quiet", "build:fast" }, { cwd = root, text = true }, function(result)
        vim.schedule(function()
            if result.code == 0 then
                vim.notify("peek.nvim build complete", vim.log.levels.INFO, { title = "peek.nvim" })
            else
                vim.notify(result.stderr, vim.log.levels.ERROR, { title = "peek.nvim build failed" })
            end
        end)
    end)
end, { desc = "Build peek.nvim with deno" })

vim.keymap.set("n", "<leader>mb", "<cmd>PeekToggle<CR>", { desc = "Markdown Peek Preview" })
