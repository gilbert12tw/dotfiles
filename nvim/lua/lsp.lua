require("mason").setup()

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>rf", vim.lsp.buf.format, { desc = "Format Local buffer" })

vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰌵",
        },
    },
    underline = false,
    update_in_insert = false,
    severity_sort = true,
})

local diagnostic_cache = {}
local show_diagnostics = {}

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, params, ctx)
    if err ~= nil or params == nil or params.uri == nil then
        return
    end

    local bufnr = vim.fn.bufnr(vim.uri_to_fname(params.uri))
    if bufnr == -1 then
        return
    end

    diagnostic_cache[bufnr] = diagnostic_cache[bufnr] or {}
    diagnostic_cache[bufnr][ctx.client_id] = params

    if show_diagnostics[bufnr] then
        vim.lsp.diagnostic.on_publish_diagnostics(err, params, ctx)
    end
end

vim.api.nvim_create_autocmd({ "InsertEnter", "TextChanged", "TextChangedI" }, {
    desc = "Hide LSP diagnostics while editing",
    callback = function(args)
        show_diagnostics[args.buf] = false
        vim.diagnostic.reset(nil, args.buf)
    end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
    desc = "Publish LSP diagnostics after saving",
    callback = function(args)
        show_diagnostics[args.buf] = true

        for client_id, params in pairs(diagnostic_cache[args.buf] or {}) do
            vim.lsp.diagnostic.on_publish_diagnostics(nil, params, { client_id = client_id })
        end
    end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

vim.lsp.enable({
    "lua_ls",
    "marksman",
    "gopls",
})
