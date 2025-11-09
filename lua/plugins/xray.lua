-- xray.nvim - Advanced diagnostic management plugin
return {
  "sfn101/xray.nvim",
  priority = 1000,
  dependencies = {
    "folke/which-key.nvim",
  },
  config = function()
    require("xray").setup({
      -- Optional: customize default configuration here
      -- state_file = vim.fn.stdpath("data") .. "/xray_state.json",
      -- defaults = {
      --   modes = { ERROR = true, WARN = true, INFO = true, HINT = true },
      --   enabled = { ERROR = true, WARN = true, INFO = true, HINT = true },
      --   focus_default = false,
      -- },
    })
  end,
}
