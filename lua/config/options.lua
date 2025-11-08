-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Define diagnostic highlight groups if not set by theme
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff0000" })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#ffa500" })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#00ffff" })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#808080" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, fg = "#ff0000" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, fg = "#ffa500" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, fg = "#00ffff" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, fg = "#808080" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ff0000" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ffa500" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#00ffff" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#808080" })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#ff0000" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#ffa500" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#00ffff" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#808080" })

vim.diagnostic.config({
  underline = true,
})
