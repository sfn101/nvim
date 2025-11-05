-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local original_virtual_text_show = vim.diagnostic.handlers.virtual_text.show
    local original_virtual_text_hide = vim.diagnostic.handlers.virtual_text.hide
    local original_virtual_lines_show = vim.diagnostic.handlers.virtual_lines.show
    local original_virtual_lines_hide = vim.diagnostic.handlers.virtual_lines.hide

    vim.diagnostic.handlers.virtual_text = {
      show = function(namespace, bufnr, diagnostics, opts)
        local filtered = vim.tbl_filter(function(diag)
          return diag.severity == vim.diagnostic.severity.WARN or diag.severity == vim.diagnostic.severity.INFO
        end, diagnostics)
        if #filtered > 0 then
          original_virtual_text_show(namespace, bufnr, filtered, opts)
        end
      end,
      hide = function(namespace, bufnr)
        original_virtual_text_hide(namespace, bufnr)
      end,
    }

    vim.diagnostic.handlers.virtual_lines = {
      show = function(namespace, bufnr, diagnostics, opts)
        local filtered = vim.tbl_filter(function(diag)
          return diag.severity == vim.diagnostic.severity.ERROR
        end, diagnostics)
        if #filtered > 0 then
          original_virtual_lines_show(namespace, bufnr, filtered, opts)
        end
      end,
      hide = function(namespace, bufnr)
        original_virtual_lines_hide(namespace, bufnr)
      end,
    }

    vim.diagnostic.config({
      virtual_text = true,
      virtual_lines = true,
    })
  end,
})
