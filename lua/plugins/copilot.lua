return {
  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set("i", "<C-Right>", "<Plug>(copilot-accept-word)")
    end,
  },
}