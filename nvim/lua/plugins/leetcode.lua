local previous_showtabline

require("leetcode").setup({
    arg = "leetcode.nvim",
    lang = "cpp",
    storage = {
        home = vim.fn.expand("~/CP/leetcode"),
        cache = vim.fn.stdpath("cache") .. "/leetcode",
    },
    picker = {
        provider = "snacks-picker",
    },
    plugins = {
        non_standalone = true,
    },
    editor = {
        reset_previous_code = true,
        fold_imports = true,
    },
    injector = {
        cpp = {
            imports = function()
                return {
                    "#include <bits/stdc++.h>",
                    "using namespace std;",
                }
            end,
        },
    },
    description = {
        position = "left",
        width = "40%",
        show_stats = true,
    },
    console = {
        open_on_runcode = true,
        dir = "row",
        size = {
            width = "90%",
            height = "75%",
        },
        result = {
            size = "60%",
        },
        testcase = {
            virt_text = true,
            size = "40%",
        },
    },
    hooks = {
        enter = {
            function()
                previous_showtabline = previous_showtabline or vim.o.showtabline
                vim.o.showtabline = 0
            end,
        },
        leave = {
            function()
                if previous_showtabline then
                    vim.o.showtabline = previous_showtabline
                    previous_showtabline = nil
                end
            end,
        },
    },
})

vim.keymap.set("n", "<leader>ll", "<cmd>Leet list<cr>", { desc = "LeetCode list" })
vim.keymap.set("n", "<leader>ld", "<cmd>Leet daily<cr>", { desc = "LeetCode daily" })
vim.keymap.set("n", "<leader>lr", "<cmd>Leet run<cr>", { desc = "LeetCode run" })
vim.keymap.set("n", "<leader>ls", "<cmd>Leet submit<cr>", { desc = "LeetCode submit" })
vim.keymap.set("n", "<leader>lc", "<cmd>Leet console<cr>", { desc = "LeetCode console" })
vim.keymap.set("n", "<leader>lt", "<cmd>Leet tabs<cr>", { desc = "LeetCode tabs" })
