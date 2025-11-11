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
      -- focus_fallback_column = "first_non_ws", -- or "eol"
    })
  end,
}
