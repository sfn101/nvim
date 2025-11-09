# Neovim LazyVim Configuration

This is a customized Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim), a starter template for Neovim with a modern plugin management system.

## Features

### Custom Plugins

#### 1. Xray - Diagnostic Management (Custom Plugin)

**Repository:** [sfn101/xray.nvim](https://github.com/sfn101/xray.nvim)

A custom diagnostic display plugin with persistent state management and flexible display modes. This plugin provides granular control over how LSP diagnostics are displayed in your editor.

**Features:**
- Per-severity visibility control (ERROR, WARN, INFO, HINT)
- Two display modes: virtual text (inline) or virtual lines (multiline)
- Focus mode: shows diagnostics only on current cursor line
- State persistence across sessions
- Seamless integration with LSP servers

**Visibility Toggles:**
- `gla`: Toggle all diagnostics on/off (exits focus mode first if active)
- `gle`: Toggle ERROR diagnostics on/off
- `glw`: Toggle WARN/INFO/HINT diagnostics on/off together

**Display Mode Toggles:**
- `glse`: Toggle ERROR display mode (virtual text ↔ virtual lines)
- `glsw`: Toggle WARN display mode (virtual text ↔ virtual lines)
- `glsi`: Toggle INFO display mode (virtual text ↔ virtual lines)
- `glsh`: Toggle HINT display mode (virtual text ↔ virtual lines)
- `glsc`: Reset all severities to virtual text mode (default)

**Focus Mode:**
- `glf`: Toggle focus mode (show diagnostics only on current line, respects display settings)
- `glsf`: Toggle focus mode as default on startup (persisted across sessions)

**Focus Mode Features:**
- Shows diagnostics only on the current cursor line
- Updates automatically as you move the cursor
- Respects current virtual text/lines settings for each severity
- Respects enabled/disabled state for each severity
- Any `gls*` command exits focus mode to adjust settings

**State Persistence:**
- All settings are automatically saved to `~/.local/share/nvim/xray_state.json`
- Settings persist across Neovim sessions
- Stores: display modes, enabled states, and focus mode default

**Implementation Details:**
- Uses custom namespace for focus mode diagnostics
- Automatic CursorMoved/CursorMovedI autocmd for focus mode updates
- JSON-based state serialization
- Early loading in init phase to ensure proper setup

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
