# Neovim LazyVim Configuration

A customized Neovim setup based on [LazyVim](https://github.com/LazyVim/LazyVim) with enhanced diagnostics, multi-cursor editing, and terminal management.

## Features

- **Tiny Inline Diagnostic**: Inline LSP diagnostics without line shifting. Commands: `:TinyInlineDiag toggle`.
- **Multicursor**: VS Code-style multi-cursor editing with `<C-n>`, `<C-x>`, etc.
- **Snacks Terminal**: Toggle terminal with `<leader>t`, exits with single `ESC`.
- Standard LazyVim plugins: CMP, Copilot, LSP, Snacks, Rainbow Delimiters, Indent Blankline.

## Installation

1. Clone this repository to your Neovim config directory:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

2. Launch Neovim and Lazy will automatically install all plugins.

## Key Mappings

- `jj`: Insert to normal mode
- `<C-s>`: Save file (prompts if untitled)
- `<leader>fw`: Save file
- `<leader>fs`: Save file as
- `<leader>t`: Toggle terminal (ESC to exit)
- Multicursor: `<C-n>`, `<C-x>`, `<C-Up>`, `<C-Down>`, `<C-LeftMouse>`, `<Esc>`
- See [LazyVim docs](https://www.lazyvim.org/keymaps) for more.

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
