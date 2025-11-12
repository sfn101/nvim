return {
  {
    "github/copilot.vim",
    config = function()
      -- Dismiss Copilot suggestion
      vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)")

      -- Accept one word
      vim.keymap.set("i", "<C-Right>", "<Plug>(copilot-accept-word)")

      -- Cycle suggestions
      vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)")
      vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)")

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
