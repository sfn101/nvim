return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Disable LazyVim's virtual text/lines - let xray.nvim handle diagnostic display
      -- But keep underline enabled for xray to use
      diagnostics = {
        underline = true,
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
