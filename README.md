# Neovim LazyVim Configuration

This is a customized Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim), a starter template for Neovim with a modern plugin management system.

## Features

### Diagnostic Management
- **Which-Key Menu**: Access diagnostic toggles under the `gl` prefix
  - `gla`: Toggle all diagnostics (virtual text + virtual lines)
  - `gll`: Toggle virtual lines
  - `glt`: Toggle virtual text
  - `glf`: Toggle focus mode (show diagnostics only on current line)

- **Focus Mode**: Hide all diagnostics except those on the current cursor line, updating as you move the cursor.

- **Diagnostic Underlines**: Enabled underlines for all diagnostic severities (error, warn, info, hint) with proper highlighting.

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

- Custom diagnostic toggles under `gl` prefix (see Features section)
- Standard LazyVim keybindings apply

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
