return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 60,                 -- 右側寬度
      direction = "vertical",    -- 垂直分割
      persist_size = true,
      persist_mode = true,
      shade_terminals = true,
      start_in_insert = true,
    })

    local Terminal  = require("toggleterm.terminal").Terminal
    local right_term = Terminal:new({
      direction = "vertical",
      size = 40,
      hidden = true,
    })

    function _RIGHT_TERM_TOGGLE()
      right_term:toggle()
    end

    vim.keymap.set({ "n" }, "<leader>tt", "<cmd>lua _RIGHT_TERM_TOGGLE()<CR>", {
      noremap = true,
      silent = true,
      desc = "Toggle right terminal",
    })
  end,
}
