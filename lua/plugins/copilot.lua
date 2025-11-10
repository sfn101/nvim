return {
  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set("i", "<C-Right>", "<Plug>(copilot-accept-word)")
      
      -- Hide Copilot ghost text when cmp menu is visible
      local cmp = require("cmp")
      
      cmp.event:on("menu_opened", function()
        vim.b.copilot_suggestion_hidden = 1
      end)
      
      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = 0
      end)
    end,
  },
}
