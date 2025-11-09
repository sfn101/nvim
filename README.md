# Neovim LazyVim Configuration

This is a customized Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim), a starter template for Neovim with a modern plugin management system.

## Features

### Diagnostic Management (Xray Plugin)

A custom diagnostic display plugin with persistent state management and flexible display modes.

#### Visibility Toggles
- `gla`: Toggle all diagnostics on/off (exits focus mode first if active)
- `gle`: Toggle ERROR diagnostics on/off
- `glw`: Toggle WARN/INFO/HINT diagnostics on/off together

#### Display Mode Toggles
- `glse`: Toggle ERROR display mode (virtual text ↔ virtual lines)
- `glsw`: Toggle WARN display mode (virtual text ↔ virtual lines)
- `glsi`: Toggle INFO display mode (virtual text ↔ virtual lines)
- `glsh`: Toggle HINT display mode (virtual text ↔ virtual lines)
- `glsc`: Reset all severities to virtual text mode (default)

#### Focus Mode
- `glf`: Toggle focus mode (show diagnostics only on current line, respects display settings)
- `glsf`: Toggle focus mode as default on startup (persisted across sessions)

**Focus Mode Features:**
- Shows diagnostics only on the current cursor line
- Updates automatically as you move the cursor
- Respects current virtual text/lines settings for each severity
- Respects enabled/disabled state for each severity
- Any `gls*` command exits focus mode to adjust settings

#### State Persistence
- All settings are automatically saved to `~/.local/share/nvim/xray_state.json`
- Settings persist across Neovim sessions
- Stores: display modes, enabled states, and focus mode default

#### Diagnostic Underlines
- Enabled for all diagnostic severities (error, warn, info, hint)
- Proper highlighting with color-coded underlines

### Plugins
- CMP (Completion)
- Copilot
- LSP (Language Server Protocol)
- Snacks
- ToggleTerm

## Installation

1. Clone this repository to your Neovim config directory:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

2. Launch Neovim and Lazy will automatically install all plugins.

## Key Mappings

### Diagnostic Toggles (`gl` prefix)

| Key | Action |
|-----|--------|
| `gla` | Toggle all diagnostics on/off |
| `gle` | Toggle ERROR diagnostics on/off |
| `glw` | Toggle WARN/INFO/HINT diagnostics on/off |
| `glf` | Toggle focus mode (current line only) |
| `glse` | Toggle ERROR display mode (text ↔ lines) |
| `glsw` | Toggle WARN display mode (text ↔ lines) |
| `glsi` | Toggle INFO display mode (text ↔ lines) |
| `glsh` | Toggle HINT display mode (text ↔ lines) |
| `glsc` | Reset all to virtual text mode |
| `glsf` | Toggle focus mode as default on startup |

### Standard LazyVim Keybindings
- All standard LazyVim keybindings apply
- See [LazyVim documentation](https://www.lazyvim.org/keymaps) for complete list

## Customization

This config includes custom highlight groups for diagnostics:
- DiagnosticError, DiagnosticWarn, DiagnosticInfo, DiagnosticHint
- DiagnosticUnderlineError, DiagnosticUnderlineWarn, DiagnosticUnderlineInfo, DiagnosticUnderlineHint
- DiagnosticVirtualTextError, DiagnosticVirtualTextWarn, DiagnosticVirtualTextInfo, DiagnosticVirtualTextHint
- DiagnosticSignError, DiagnosticSignWarn, DiagnosticSignInfo, DiagnosticSignHint

## Development

### Formatting
- Lua: `stylua .`
- General: `biome format --write .`

### Linting
- Shell: `shellcheck **/*.sh`
- Python: `flake8 **/*.py`

## License

See LICENSE file for details.
