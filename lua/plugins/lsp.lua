return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = {
          severity = { min = 1 },
        },
      },
    },
  },
}