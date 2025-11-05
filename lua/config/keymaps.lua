-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local virtual_text_enabled = true
local virtual_lines_enabled = true
local focus_mode_enabled = false
local focus_ns = vim.api.nvim_create_namespace('diagnostic_focus')

local function toggle_text()
  virtual_text_enabled = not virtual_text_enabled
  vim.diagnostic.config({ virtual_text = virtual_text_enabled })
end

local function toggle_line()
  virtual_lines_enabled = not virtual_lines_enabled
  vim.diagnostic.config({ virtual_lines = virtual_lines_enabled })
end

local function toggle_focus()
  focus_mode_enabled = not focus_mode_enabled
  if focus_mode_enabled then
    -- Hide all diagnostics initially
    vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
    -- Set up autocmd to show only on current line
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = vim.api.nvim_create_augroup("diagnostic_focus", { clear = true }),
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_loaded(bufnr) then return end
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1
        vim.diagnostic.hide(focus_ns, bufnr)
        local all_diags = vim.diagnostic.get(bufnr)
        local current_diags = vim.tbl_filter(function(d) return d.lnum == line end, all_diags)
        vim.diagnostic.show(focus_ns, bufnr, current_diags, {
          virtual_text = virtual_text_enabled,
          virtual_lines = virtual_lines_enabled,
        })
      end,
    })
  else
    -- Hide focus diagnostics and restore global
    vim.diagnostic.hide(focus_ns)
    vim.diagnostic.config({ virtual_text = virtual_text_enabled, virtual_lines = virtual_lines_enabled })
    -- Remove autocmd
    vim.api.nvim_del_augroup_by_name("diagnostic_focus")
  end
end

local function toggle_all()
  if focus_mode_enabled then
    toggle_focus()
    virtual_text_enabled = true
    virtual_lines_enabled = true
    vim.diagnostic.config({ virtual_text = true, virtual_lines = true })
  else
    if virtual_text_enabled == virtual_lines_enabled then
      virtual_text_enabled = not virtual_text_enabled
      virtual_lines_enabled = not virtual_lines_enabled
    else
      virtual_text_enabled = true
      virtual_lines_enabled = true
    end
    vim.diagnostic.config({ virtual_text = virtual_text_enabled, virtual_lines = virtual_lines_enabled })
  end
end

local wk = require("which-key")
wk.add({
  { "gl", group = "diagnostics" },
  { "gla", toggle_all, desc = "Toggle all (virtual text + virtual lines)" },
  { "gll", toggle_line, desc = "Toggle virtual lines" },
  { "glt", toggle_text, desc = "Toggle virtual text" },
  { "glf", toggle_focus, desc = "Toggle focus mode (cursor line only)" },
})

-- Enable focus mode by default
toggle_focus()
