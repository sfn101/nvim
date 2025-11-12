return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { virtual_text = false },
      servers = {
        lua_ls = {},
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
