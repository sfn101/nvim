# Opencode Agent Configuration

Documents Neovim LazyVim config issues and solutions.

## Current Configurations

### Snacks Terminal
- **File**: `lua/plugins/snacks.lua`, `lua/config/keymaps.lua`
- **Description**: Terminal toggle with `<leader>t`, single ESC exit.
- **Config**: Override `term_normal` in `win.keys` for single ESC. No floating, bottom split.
- **Issue**: Default double-ESC changed to single by overriding key.

### Diagnostic Underlines
- **Files**: `lua/config/options.lua`, `lua/plugins/lsp.lua`
- **Description**: Underlines for all diagnostic severities.
- **Config**: `diagnostics = { underline = true }` in lsp.lua, `vim.diagnostic.config({ underline = true })` in options.lua.
- **Issue**: Missing highlight groups fixed by defining in options.lua.

## Highlight Groups
- DiagnosticError/Warn/Info/Hint
- DiagnosticUnderline*
- DiagnosticVirtualText*
- DiagnosticSign*

## Build/Lint Commands
- Lua: `stylua .`
- Code: `biome format --write .`
- Shell: `shellcheck **/*.sh`
- Python: `flake8 **/*.py`

## Notes
- Removed toggleterm, cleaned extras.
- Simplified README and keys.
- Define highlight groups if theme lacks them.
- Override snacks keys minimally for custom behavior.


