-- lutos - Workspace color bar (like VSCode Peacock)
return {
  "sfn101/lutos.nvim",
  dependencies = {
    "folke/which-key.nvim",
  },
  config = function()
    require("lutos").setup({
      bar_width = 2, -- Width of the colored bar
    })
  end,
}
