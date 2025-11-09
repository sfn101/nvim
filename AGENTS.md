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

## Migration to Standalone xray.nvim Plugin (Nov 9, 2025)

### Completed Tasks
1. **Created standalone xray.nvim repository** in `/home/sfn/.config/nvim/xray.nvim/`
   - Modular structure with separate files for init, config, and state management
   - Complete with README, LICENSE (MIT), and .gitignore

2. **Updated main nvim config** to use xray.nvim as external plugin
   - Modified `lua/plugins/xray.lua` to load from local directory using `dir` option
   - Plugin loads with lazy.nvim priority 1000
   - Depends on which-key for keymap menu

3. **File structure created**:
   ```
   xray.nvim/
   ├── lua/xray/
   │   ├── init.lua      (main plugin logic, keymap setup, focus mode)
   │   ├── config.lua    (configuration management)
   │   └── state.lua     (JSON state persistence)
   ├── plugin/xray.lua   (plugin loader guard)
   ├── README.md         (comprehensive usage documentation)
   ├── LICENSE           (MIT license)
   └── .gitignore
   ```

### Current Configuration
- **GitHub repository**: `sfn101/xray.nvim`
- **State file**: `~/.local/share/nvim/xray_state.json`
- All existing keymaps under `gl` prefix preserved
- Focus mode and state persistence working as before

### Plugin Installation
Main nvim config now uses GitHub repository:
```lua
return {
  "sfn101/xray.nvim",
  priority = 1000,
  dependencies = { "folke/which-key.nvim" },
  config = function()
    require("xray").setup({})
  end,
}
```

### Testing Performed
- ✅ Neovim headless test passed without errors
- ✅ All xray.nvim files verified in correct locations
- ✅ Plugin loader structure confirmed working
- ✅ GitHub repository configured and ready to use
