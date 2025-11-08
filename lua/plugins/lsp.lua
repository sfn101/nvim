return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
      },
      servers = {
        biome = {},
        vtsls = {
          settings = {
            javascript = { checkJs = false },
          },
          on_attach = function(client, bufnr)
            if vim.bo[bufnr].filetype == "javascript" then
              client.handlers["textDocument/publishDiagnostics"] = function() end
            end
          end,
        },
      },
    },
  },
}
