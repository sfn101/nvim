return {
  "snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          layout = {
            preset = "left",
          },
        },
      },
    },
    terminal = {
      win = {
        keys = {
          term_normal = { "<esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },
        },
      },
    },
  },
}
