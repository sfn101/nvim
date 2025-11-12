# Neovim LazyVim Configuration

This is a customized Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim), a starter template for Neovim with a modern plugin management system.

## Features

### Custom Plugins

#### 1. Tiny Inline Diagnostic - Modern Diagnostic Display

**Repository:** [rachartier/tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim)

A modern plugin for displaying LSP diagnostics as inline virtual text with customizable styles and icons. Provides clean, unobtrusive diagnostic display without moving code lines.

**Features:**
- Inline diagnostic display (no line shifting like virtual_lines)
- Customizable presets (modern, classic, minimal, powerline, ghost, simple, nonerdfont, amongus)
- Multiline diagnostic support for long messages
- Overflow handling (wrap, none, oneline)
- Source display (show LSP server names)
- Related diagnostics support
- Per-severity filtering and display control
- Commands: `:TinyInlineDiag enable/disable/toggle`

**Commands:**
- `:TinyInlineDiag enable` - Enable inline diagnostics
- `:TinyInlineDiag disable` - Disable inline diagnostics
- `:TinyInlineDiag toggle` - Toggle diagnostics on/off

**API:**
- `require("tiny-inline-diagnostic").change_severities({severities})` - Filter by severity
- `require("tiny-inline-diagnostic").enable()` / `disable()` / `toggle()` - Control visibility

#### 2. ToggleTerm - Enhanced Terminal Management

Custom terminal management system built on top of [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim).

**Features:**
- Multiple persistent terminals with cycling
- Floating and fullscreen terminal modes
- Terminal-specific keymaps for resizing
- Smart terminal window tracking
- ESC to exit terminal mode

**Terminal Types:**
- Normal terminals: IDs 1-97 (created on demand)
- Float terminal: ID 99 (`<leader>jf`)
- Fullscreen terminal: ID 98 (`<leader>jF`)

**Terminal Management:**
- `<leader>jj`: Toggle all normal terminals (or create first)
- `<leader>jn`: Create a new terminal
- `<leader>jk`: Kill current terminal
- `<leader>jK`: Kill all normal terminals
- `<leader>j*`: Kill all terminals (including float and fullscreen)
- `<leader>jf`: Toggle floating terminal
- `<leader>jF`: Toggle fullscreen terminal (tab)

**Terminal Navigation:**
- `[j`: Previous terminal
- `]j`: Next terminal

**Terminal Resizing (works in terminal mode too):**
- `<leader>j=`: Increase terminal height
- `<leader>j-`: Decrease terminal height
- `<leader>j\`: Increase terminal width
- `<leader>j|`: Decrease terminal width

**Configuration:**
- Default size: 15 lines (horizontal split)
- Curved borders for floating terminal
- Persistent sizing across toggles
- Auto-close on process exit

#### 3. Multicursor - VS Code-Style Multi-Cursor Editing

Multi-cursor editing powered by [jake-stewart/multicursor.nvim](https://github.com/jake-stewart/multicursor.nvim).

**Features:**
- Select multiple occurrences of word under cursor
- Skip unwanted matches
- Add cursors vertically (column editing)
- Mouse support for cursor placement
- Visual mode support

**Keymaps:**
- `<C-n>`: Select word under cursor, press again for next occurrence (normal/visual)
- `<C-x>`: Skip current match and select next (normal/visual)
- `<C-Up>`: Add cursor above current line (normal/visual)
- `<C-Down>`: Add cursor below current line (normal/visual)
- `<C-LeftMouse>`: Add cursor at mouse position (normal)
- `<Esc>`: Clear all cursors (or enable cursors if disabled)

**Workflow Example:**
1. Place cursor on a word
2. Press `<C-n>` to select it
3. Press `<C-n>` again to select next occurrence
4. Press `<C-x>` to skip unwanted matches
5. Start typing to edit all occurrences simultaneously

### Standard LazyVim Plugins
- **CMP**: Auto-completion with LSP integration
- **Copilot**: AI-powered code suggestions
- **LSP**: Language Server Protocol support
- **Snacks**: UI enhancements
- **Rainbow Delimiters**: Colorized matching brackets
- **Indent Blankline**: Visual indentation guides

## Installation

1. Clone this repository to your Neovim config directory:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

2. Launch Neovim and Lazy will automatically install all plugins.

## Key Mappings

### General Keymaps

| Key | Mode | Action |
|-----|------|--------|
| `jj` | Insert | Escape to normal mode |
| `<C-s>` | Insert/Normal/Visual | Save file (prompts if untitled) |
| `<leader>fw` | Normal | Save file |
| `<leader>fs` | Normal | Save file as (always prompts) |



### Terminal Management (`<leader>j` prefix)

| Key | Action |
|-----|--------|
| `<leader>jj` | Toggle all normal terminals (or create first) |
| `<leader>jn` | Create new terminal |
| `<leader>jk` | Kill current terminal |
| `<leader>jK` | Kill all normal terminals |
| `<leader>j*` | Kill all terminals (including special) |
| `<leader>jf` | Toggle floating terminal |
| `<leader>jF` | Toggle fullscreen terminal (tab) |
| `<leader>j=` | Increase terminal height |
| `<leader>j-` | Decrease terminal height |
| `<leader>j\` | Increase terminal width |
| `<leader>j\|` | Decrease terminal width |
| `[j` | Cycle to previous terminal |
| `]j` | Cycle to next terminal |
| `<Esc>` | Exit terminal mode (in terminal) |

### Multi-Cursor (`<C-*>` prefix)

| Key | Mode | Action |
|-----|------|--------|
| `<C-n>` | Normal/Visual | Select word under cursor / next occurrence |
| `<C-x>` | Normal/Visual | Skip current match and select next |
| `<C-Up>` | Normal/Visual | Add cursor above |
| `<C-Down>` | Normal/Visual | Add cursor below |
| `<C-LeftMouse>` | Normal | Add cursor at mouse position |
| `<Esc>` | Normal | Clear all cursors |

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
