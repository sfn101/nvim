return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Disable LazyVim's diagnostic config - let xray.nvim handle ALL diagnostic display
      diagnostics = {
        underline = false,
        update_in_insert = false,
        virtual_text = false,
        virtual_lines = false,
      },
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
