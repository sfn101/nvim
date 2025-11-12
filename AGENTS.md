# Opencode Agent Configuration

This file documents the Neovim LazyVim configuration and issues encountered during setup, to help the opencode agent avoid similar problems in the future.

## Key Configurations

### Which-Key Menu for Diagnostics
- **File**: `lua/config/keymaps.lua`
- **Description**: Added a which-key menu under `gl` for toggling diagnostics.
- **Mappings**:
  - `gla`: Toggle all (virtual text + virtual lines)
  - `gll`: Toggle virtual lines
  - `glt`: Toggle virtual text
  - `glf`: Toggle focus mode (show diagnostics only on current line)
- **Issue**: Old which-key spec caused warnings. Updated to new spec format using `wk.add()` with `{ "gl", group = "diagnostics" }` and individual key mappings.

### Focus Mode Implementation
- **File**: `lua/config/keymaps.lua`
- **Description**: Focus mode hides all diagnostics and shows only those on the current cursor line using a custom namespace.
- **Implementation**:
  - Uses `vim.api.nvim_create_namespace('diagnostic_focus')` for custom namespace.
  - Hides global diagnostics, shows filtered diagnostics in custom namespace.
  - CursorMoved autocmd updates on movement.
- **Issues**:
  - Initial attempts failed due to namespace errors ("Cannot show diagnostics without a buffer and namespace").
  - Fixed by using a custom namespace instead of default (nil).
  - Avoided passing bufnr to `vim.diagnostic.show()` to prevent assertion failures.

### Diagnostic Underlines
- **Files**: `lua/config/options.lua`, `lua/plugins/lsp.lua`
- **Description**: Enabled underlines for all diagnostic severities (error, warn, info, hint) with correct colors.
- **Configuration**:
  - Client config in `lsp.lua`: `diagnostics = { underline = true }`
  - Display config in `options.lua`: `vim.diagnostic.config({ underline = true })`
  - Highlight groups defined in `options.lua` with default colors.
- **Issues**:
  - Underlines not showing initially due to missing highlight groups.
  - Theme did not define `DiagnosticUnderline*` groups.
  - Fixed by explicitly defining highlight groups with underline and fg colors.
  - Moved config to `options.lua` to load early and avoid overrides.

## Highlight Groups Defined
- DiagnosticError, DiagnosticWarn, DiagnosticInfo, DiagnosticHint
- DiagnosticUnderlineError, DiagnosticUnderlineWarn, DiagnosticUnderlineInfo, DiagnosticUnderlineHint
- DiagnosticVirtualTextError, DiagnosticVirtualTextWarn, DiagnosticVirtualTextInfo, DiagnosticVirtualTextHint
- DiagnosticSignError, DiagnosticSignWarn, DiagnosticSignInfo, DiagnosticSignHint

## Build/Lint Commands
- Format Lua: `stylua .`
- Format Code: `biome format --write .`
- Lint Shell: `shellcheck **/*.sh`
- Lint Python: `flake8 **/*.py`

## Notes for Future Configurations
- Use custom namespaces for diagnostic display to avoid conflicts with default diagnostics.
- Define highlight groups explicitly if the theme doesn't provide them.
- Load diagnostic configs early in `options.lua` to prevent overrides.
- Update which-key to new spec format to avoid warnings.
- For focus mode, hide global diagnostics and show filtered in custom namespace on cursor movement.


