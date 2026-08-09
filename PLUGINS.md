# Plugin Documentation

A complete reference for every plugin in this Neovim configuration: what it does, when it kicks in, and how to use it. Keybindings are marked **(Default)** when they come from the plugin/LazyVim out of the box, or **(Custom)** when they were configured specifically in this repo.

> Leader key is `<space>`. So `<leader>ff` means `<space>` then `f` then `f`.

---

## Table of Contents

1. [Core Framework](#core-framework)
2. [AI Assistants](#ai-assistants)
3. [Completion & Snippets](#completion--snippets)
4. [LSP, Diagnostics & Tooling](#lsp-diagnostics--tooling)
5. [Formatting & Linting](#formatting--linting)
6. [Syntax & Treesitter](#syntax--treesitter)
7. [Editing Power-Tools](#editing-power-tools)
8. [Navigation, Search & Sessions](#navigation-search--sessions)
9. [UI & Notifications](#ui--notifications)
10. [Markdown Tools](#markdown-tools)
11. [Git](#git)
12. [Database Tools](#database-tools)
13. [REST / API Client](#rest--api-client)
14. [Python Tooling](#python-tooling)
15. [Custom Plugin — lutos.nvim](#custom-plugin--lutosnvim)
16. [Color Themes](#color-themes)
17. [Custom Keybindings Cheatsheet](#custom-keybindings-cheatsheet)

---

## Core Framework

Plugins that don't need any interaction — they're the plumbing everything else runs on.

- **lazy.nvim** (`folke/lazy.nvim`) — The plugin manager itself. Handles installing, lazy-loading (only loading a plugin when its command/keymap/filetype/event actually triggers), and updating everything else in this document. Opens with `:Lazy`.
- **LazyVim** (`LazyVim/LazyVim`) — The starter-kit distribution this whole config is built on. It ships sane defaults for options, keymaps, and a curated set of plugins, then lets you override anything (which is what every file in `lua/plugins/` does).
- **plenary.nvim** (`nvim-lua/plenary.nvim`) — A shared standard-library of Lua utility functions (async jobs, path handling, testing helpers) that dozens of other plugins depend on internally. You never call it directly.
- **nui.nvim** (`MunifTanjim/nui.nvim`) — A UI component toolkit (popups, inputs, menus, layouts) used internally by `noice.nvim` and others to draw their floating windows.

---

## AI Assistants

- **claudecode.nvim** (`coder/claudecode.nvim`) — Embeds Claude Code directly inside Neovim as a terminal-based coding assistant. Example: open a messy function, select it in visual mode, hit `<leader>as` to send it to Claude with a question, then review its proposed diff and accept or reject it without leaving the editor.

  | Key | Mode | Action |
  |---|---|---|
  | `<leader>ac` | n | Toggle Claude Code panel *(Default)* |
  | `<leader>af` | n | Focus Claude Code panel *(Default)* |
  | `<leader>ar` | n | Resume last session *(Default)* |
  | `<leader>aC` | n | Continue previous conversation *(Default)* |
  | `<leader>ab` | n | Add current buffer as context *(Default)* |
  | `<leader>as` | v | Send selection to Claude *(Default)* |
  | `<leader>as` | n (in file trees) | Add file under cursor as context *(Default)* |
  | `<leader>aa` | n | Accept a proposed diff *(Default)* |
  | `<leader>ad` | n | Deny a proposed diff *(Default)* |

- **windsurf.vim** (`Exafunction/windsurf.vim`) — Inline AI autocomplete (formerly Codeium; same company, rebranded as Windsurf). As you type, it shows ghost-text suggestions for the rest of the line/block. Example: start typing a function signature and it suggests the whole implementation as grey text — press `<Tab>` to accept it.

  | Key | Action |
  |---|---|
  | `<Tab>` | Accept suggestion *(Default)* |
  | `<M-]>` / `<M-[>` | Next / previous suggestion *(Default)* |
  | `<C-]>` | Clear/dismiss suggestion *(Default)* |
  | `<C-k>` / `<C-l>` | Accept next word / next line *(Default)* |
  | `<M-\>` | Manually trigger a suggestion *(Default)* |

  First-time setup: run `:Codeium Auth` once to log in.

---

## Completion & Snippets

- **nvim-cmp** (`hrsh7th/nvim-cmp`) — The autocompletion engine that powers the popup menu you see while typing. It aggregates suggestions from every source below (LSP, buffer words, file paths, snippets) into one ranked list.
- **cmp-nvim-lsp** — Feeds LSP-provided completions (functions, variables, types from your language server) into nvim-cmp.
- **cmp-buffer** — Suggests words already present in open buffers (handy for plain text or repeated identifiers).
- **cmp-path** — Suggests filesystem paths when typing something like `./` or `/`.
- **cmp-mini-snippets** — Bridges `mini.snippets` into nvim-cmp so snippet expansion shows up in the same completion menu.
- **mini.snippets** (part of mini.nvim) — Manages and expands code snippets (e.g., type `for` + expand to get a full for-loop skeleton with tab-stops).
- **friendly-snippets** — A large, community-maintained snippet collection for dozens of languages, consumed by mini.snippets so you get sensible snippets out of the box without writing your own.
- **mini.pairs** (part of mini.nvim) — Auto-closes and auto-deletes bracket/quote pairs as you type (type `(` and `)` appears automatically; backspace removes both).
- **lazydev.nvim** (`folke/lazydev.nvim`) — Makes the Lua language server understand the Neovim API (`vim.*`) properly when editing your own Neovim config, so you get accurate completion/hover for things like `vim.keymap.set`.
- **tailwindcss-colorizer-cmp.nvim** — Adds a small color swatch next to Tailwind CSS class completions in the cmp menu (e.g. `bg-red-500` shows an actual red square) so you can see the color before picking it.

  | Key | Mode | Action |
  |---|---|---|
  | `<Tab>` | insert | If cmp menu open: select next item. Else: try snippet-forward, then fall through to windsurf.vim's accept *(Custom — merges cmp navigation with AI accept)* |
  | `<S-Tab>` | insert | Select previous cmp item *(Custom)* |
  | `<CR>` | insert | Confirm selected completion *(Custom, `select = false`)* |
  | `<S-CR>` | insert | Confirm and replace word *(Custom)* |
  | `<C-Space>` | insert | Manually trigger completion *(Custom)* |
  | `<C-n>` / `<C-p>` | insert | Next / previous item *(Custom)* |
  | `<C-b>` / `<C-f>` | insert | Scroll docs window *(Custom)* |
  | `<C-e>` | insert | Abort completion *(Custom)* |
  | `<Esc>` | insert | Abort completion if menu visible, else normal escape *(Custom)* |

---

## LSP, Diagnostics & Tooling

- **nvim-lspconfig** (`neovim/nvim-lspconfig`) — Quickstart configurations for connecting Neovim's built-in LSP client to language servers (this config wires up `lua_ls`, `biome`, and `vtsls`, with a tweak so `vtsls` doesn't duplicate JS diagnostics). This is what powers go-to-definition, hover docs, and inline errors.
- **mason.nvim** (`mason-org/mason.nvim`) — A package manager for LSP servers, linters, formatters, and debuggers, all installable from inside Neovim instead of your OS package manager. Example: run `:Mason`, browse, press `i` to install a new language server.
- **mason-lspconfig.nvim** — Glue between Mason and nvim-lspconfig so servers installed via Mason are automatically registered with lspconfig.
- **tiny-inline-diagnostic.nvim** (`rachartier/tiny-inline-diagnostic.nvim`) — Replaces Neovim's default virtual-text diagnostics with a more compact inline display that doesn't shift your code around. Command: `:TinyInlineDiag toggle`.
- **inc-rename.nvim** (`smjonas/inc-rename.nvim`) — Shows a live preview of an LSP rename across the whole buffer as you type the new name, instead of renaming blind. Bound via LSP's default `grn` rename keymap.
- **fidget.nvim** (`j-hui/fidget.nvim`) — Shows a small non-intrusive corner notification for LSP progress (e.g. "Loading workspace...", "Formatting...") and general notifications, so long-running LSP work doesn't feel silent.
- **SchemaStore.nvim** (`b0o/SchemaStore.nvim`) — Supplies the JSON/YAML language servers with a huge catalog of known schemas (package.json, tsconfig.json, GitHub Actions workflows, etc.) so you get autocomplete and validation in config files automatically.

  | Key | Mode | Action |
  |---|---|---|
  | `gd` | n | Go to definition *(Default)* |
  | `gri` | n | Go to implementation *(Default)* |
  | `grr` | n | Go to references *(Default)* |
  | `grn` | n | Rename symbol (with live preview via inc-rename) *(Default)* |
  | `gra` | n/v | Code actions *(Default)* |
  | `grt` | n | Go to type definition *(Default)* |
  | `grx` | n | Run codelens *(Default)* |
  | `gO` | n | Document symbols *(Default)* |
  | `<C-w>d` | n | Show diagnostic under cursor *(Default)* |
  | `[d` / `]d` | n | Previous / next diagnostic *(Default)* |
  | `[D` / `]D` | n | First / last diagnostic *(Default)* |
  | `<leader>cm` | n | Open Mason *(Default)* |

---

## Formatting & Linting

- **conform.nvim** (`stevearc/conform.nvim`) — Runs code formatters (prettier, stylua, biome, etc.) on save or on demand, in a lightweight and predictable way. Example: save a `.lua` file and it's auto-formatted with `stylua`.
- **nvim-lint** (`mfussenegger/nvim-lint`) — Runs external linters asynchronously and surfaces their output as diagnostics, complementing whatever your LSP server already catches.

  | Key | Mode | Action |
  |---|---|---|
  | `<leader>cF` | n/v | Format injected languages (e.g. format a JS block inside a Markdown file) *(Default)* |

---

## Syntax & Treesitter

- **nvim-treesitter** (`nvim-treesitter/nvim-treesitter`) — Parses your code into a real syntax tree (instead of regex-based highlighting), which is what gives accurate syntax highlighting, indentation, and powers every "syntax aware" feature below.
- **nvim-treesitter-textobjects** — Adds syntax-aware text objects and motions: select/move/swap function arguments, function bodies, class blocks, etc. based on the actual parse tree instead of guessing from brackets.
- **nvim-ts-autotag** (`windwp/nvim-ts-autotag`) — Auto-closes and auto-renames matching HTML/JSX/Vue tags (edit `<div>` to `<section>` and the closing tag renames itself).
- **nvim-ts-context-commentstring** — Detects the correct comment syntax based on cursor position inside mixed-language files (e.g. commenting JS inside a `<script>` block in an `.html` file uses `//`, not the HTML `<!-- -->`).
- **rainbow-delimiters.nvim** (`HiPhish/rainbow-delimiters.nvim`) — Colors matching brackets/parentheses in a repeating rainbow sequence so nested code is easier to visually track.
- **indent-blankline.nvim** (`lukas-reineke/indent-blankline.nvim`) — Draws vertical indent guide lines, recolored here into a custom 7-color rainbow palette to match the bracket colors above.
- **mini.ai** (part of mini.nvim) — Extends/improves the built-in `a`/`i` text objects (`daw`, `ci"`, etc.) and adds new ones for functions, arguments, and more.

  | Key | Mode | Action |
  |---|---|---|
  | `<C-space>` | n/v | Start/expand Treesitter incremental selection *(Default)* |
  | `an` / `in` | v | Select outer/inner treesitter node *(Default)* |
  | `[n` / `]n` | n/v | Previous / next node *(Default)* |
  | `[N` / `]N` | v | Previous / next sibling node *(Default)* |

---

## Editing Power-Tools

- **mini.comment** (part of mini.nvim) — Fast line/block commenting, aware of the current filetype's comment syntax (and mixed-language files, via `nvim-ts-context-commentstring`). This replaces LazyVim's default `ts-comments.nvim` in this config, since running both caused a conflict on the same keys.
- **mini.surround** (part of mini.nvim) — Add, delete, replace, or find "surrounding" characters like quotes, brackets, or tags. Example: cursor inside `"hello"`, press `gsd"` (delete surrounding `"`) to get `hello`, or `gsa` on a word to wrap it in something new.
- **multicursor.nvim** (`jake-stewart/multicursor.nvim`) — VS Code-style multiple cursors. Example: put cursor on a variable name, `<C-n>` repeatedly to select every occurrence, then type to edit all of them simultaneously.
- **flash.nvim** (`folke/flash.nvim`) — Jump anywhere on screen (or across the whole buffer/window) by typing a couple of characters and picking a highlighted label, faster than repeated `f`/`w` motions or a full search.
- **quicker.nvim** (`stevearc/quicker.nvim`) — Improves the quickfix window (the list of search/diagnostic results): adds syntax highlighting and lets you expand more surrounding context per result.
- **grug-far.nvim** (`MagicDuck/grug-far.nvim`) — A project-wide find-and-replace UI with live preview, like a search-and-replace panel, instead of piecing together `:%s` or external tools.
- **todo-comments.nvim** (`folke/todo-comments.nvim`) — Highlights `TODO`, `FIXME`, `HACK`, `NOTE` comments in a distinct color and lets you list/search them project-wide.

  | Key | Mode | Action |
  |---|---|---|
  | `gc` / `gcc` | n/v | Toggle comment (linewise / current line) *(Default via mini.comment)* |
  | `gsa` | n/v | Add surrounding *(Default, LazyVim-remapped from mini.surround's `ys`/`sa` to avoid clashing with flash.nvim's `s`)* |
  | `gsd` | n | Delete surrounding *(Default)* |
  | `gsr` | n | Replace surrounding *(Default)* |
  | `gsf` / `gsF` | n | Find surrounding (right/left) *(Default)* |
  | `gsh` | n | Highlight surrounding *(Default)* |
  | `<C-n>` | n/v | Add cursor at next match of word under cursor *(Custom)* |
  | `<C-x>` | n/v | Skip current match, add cursor at next *(Custom)* |
  | `<C-Up>` / `<C-Down>` | n/v | Add cursor on line above/below *(Custom)* |
  | `<C-LeftMouse>` | n | Add cursor at mouse click *(Custom)* |
  | `<Esc>` | n | Clear all extra cursors *(Custom)* |
  | `s` / `S` | n/v | Flash jump / Flash Treesitter jump *(Default)* |
  | `<leader>sr` | n/v | Search and replace (grug-far) *(Default)* |
  | `<leader>st` / `<leader>sT` | n | Search todos *(Default)* |
  | `<leader>xt` / `<leader>xT` | n | Todo list in Trouble *(Default)* |
  | `>` / `<` | n (in quickfix window) | Expand / collapse context around a result *(Custom)* |

---

## Navigation, Search & Sessions

- **snacks.nvim** (`folke/snacks.nvim`) — A large bundle of quality-of-life modules folded into one plugin: fuzzy file/text picker, file explorer, floating terminal, dashboard, and more. This config customizes its file explorer to open on the left and makes its terminal exit with a single `Esc`. Example: `<leader>ff` opens a fuzzy file finder; `<leader>e` opens the file explorer sidebar.
- **persistence.nvim** (`folke/persistence.nvim`) — Automatically saves your window/buffer layout per project directory and lets you restore it, so reopening a project brings back the same files and splits you left open.

  | Key | Mode | Action |
  |---|---|---|
  | `<leader>ff` | n | Find files (root dir) *(Default, via snacks)* |
  | `<leader>fF` | n | Find files (cwd) *(Default)* |
  | `<leader>fg` | n | Find git-tracked files *(Default)* |
  | `<leader>fr` / `<leader>fR` | n | Recent files *(Default)* |
  | `<leader>fb` / `<leader>fB` | n | List buffers *(Default)* |
  | `<leader>e` / `<leader>E` | n | File explorer (root / cwd) *(Default)* |
  | `<leader>t` | n | Toggle floating terminal *(Custom)* — exits with a single `Esc` *(Custom)* |
  | `<leader>/` `<leader>sg` | n | Live grep (root dir) *(Default)* |
  | `<leader>sw` / `<leader>sW` | n/v | Grep word/selection under cursor *(Default)* |
  | `<leader>gs` / `<leader>gd` | n | Git status / diff pickers *(Default)* |
  | `<leader>qs` / `<leader>ql` | n | Restore session / restore last session *(Default)* |
  | `<leader>qS` / `<leader>qd` | n | Select session / don't save current session *(Default)* |

---

## UI & Notifications

- **bufferline.nvim** (`akinsho/bufferline.nvim`) — Draws the tab-like row of open buffers at the top of the window, so you can see and click between open files like browser tabs.
- **lualine.nvim** (`nvim-lualine/lualine.nvim`) — The statusline at the bottom: mode, git branch, diagnostics count, filetype, position, etc.
- **noice.nvim** (`folke/noice.nvim`) — Replaces Neovim's plain command line and message area with nicer floating UI: command line becomes a popup, search shows a virtual counter, LSP hover docs get a clean border.
- **which-key.nvim** (`folke/which-key.nvim`) — Shows a popup of available keybindings whenever you pause partway through a key combo (e.g. press `<leader>` and wait — a menu of everything under it appears). This is also how the custom `<leader>f` and `<leader>t` groups in this config are labeled.
- **trouble.nvim** (`folke/trouble.nvim`) — A dedicated, prettified list view for diagnostics, LSP references, quickfix, and todo comments, easier to scan than the built-in quickfix window.
- **mini.animate** (part of mini.nvim) — Adds smooth animations to common actions like cursor movement, window resize, and scrolling.
- **mini.indentscope** (part of mini.nvim) — Highlights and animates the indent scope your cursor is currently inside (a vertical line that "grows" to show the current block).
- **mini.hipatterns** (part of mini.nvim) — Highlights specific text patterns inline — e.g. hex color codes like `#e06c75` get a live color swatch next to them.
- **mini.icons** (part of mini.nvim) — Provides consistent filetype/kind icons used throughout the UI (file explorer, statusline, completion menu, etc.).

  | Key | Mode | Action |
  |---|---|---|
  | `<leader>un` | n | Dismiss all notifications *(Default)* |
  | `<leader>sn` | n | Noice picker submenu (history, last message, all, dismiss) *(Default)* |
  | `<leader>xx` / `<leader>xX` | n | Diagnostics / buffer diagnostics (Trouble) *(Default)* |
  | `<leader>cs` / `<leader>cS` | n | Symbols / LSP references (Trouble) *(Default)* |
  | `<leader>xq` / `<leader>xl` | n | Quickfix / location list (Trouble) *(Default)* |
  | `H` / `L` | n | Previous / next buffer *(Default)* |
  | `<leader>bp` | n | Pin buffer *(Default)* |
  | `<leader>bP` | n | Delete non-pinned buffers *(Default)* |

---

## Markdown Tools

- **render-markdown.nvim** (`MeanderingProgrammer/render-markdown.nvim`) — Renders Markdown *inline* while you edit it — headers get styled, checkboxes become real checkbox glyphs, code blocks get a border — without leaving the editor or opening a preview window.
- **markdown-preview.nvim** (`iamcco/markdown-preview.nvim`) — Opens a live-updating preview of the current Markdown file in your actual web browser, for full CSS-rendered fidelity render-markdown.nvim can't do inline.

  | Key | Mode | Action |
  |---|---|---|
  | `<leader>cp` | n | Toggle markdown-preview in browser *(Default)* |

---

## Git

- **gitsigns.nvim** (`lewis6991/gitsigns.nvim`) — Shows a colored sign in the gutter for added/changed/deleted lines compared to the last commit, and lets you stage, reset, preview, or blame individual hunks without leaving the buffer.

  | Key | Mode | Action |
  |---|---|---|
  | `]h` / `[h` | n | Next / previous hunk *(Default)* |
  | `]H` / `[H` | n | Last / first hunk *(Default)* |
  | `<leader>ghs` / `<leader>ghr` | n/v | Stage / reset hunk *(Default)* |
  | `<leader>ghS` / `<leader>ghR` | n | Stage / reset entire buffer *(Default)* |
  | `<leader>ghu` | n | Undo stage hunk *(Default)* |
  | `<leader>ghp` | n | Preview hunk inline *(Default)* |
  | `<leader>ghb` / `<leader>ghB` | n | Blame line / blame buffer *(Default)* |
  | `<leader>ghd` / `<leader>ghD` | n | Diff this / diff against `~` *(Default)* |
  | `ih` | o/v | Text object: select current hunk *(Default)* |
  | `<leader>uG` | n | Toggle git signs on/off *(Default)* |

---

## Database Tools

- **vim-dadbod** (`tpope/vim-dadbod`) — The underlying database connection engine — connects to Postgres, MySQL, SQLite, and more, and runs queries against them.
- **vim-dadbod-ui** (`kristijanhusak/vim-dadbod-ui`) — A visual UI on top of vim-dadbod: browse connections, tables, and schemas, and run queries from a side panel instead of the command line.
- **vim-dadbod-completion** — Autocompletes table and column names in `.sql` buffers based on the connected database's actual schema.

  | Key | Mode | Action |
  |---|---|---|
  | `D` | n | Toggle the database UI *(Default)* |

---

## REST / API Client

- **kulala.nvim** (`mistweaverco/kulala.nvim`) — A full HTTP/GraphQL/gRPC/WebSocket client inside Neovim (like Postman or Insomnia, but as `.http` files you write and run with a keypress). Example: write a `GET https://api.example.com/users` block in a `.http` file, hit `<leader>Rr`, and see the JSON response in a split.

  | Key | Mode | Action |
  |---|---|---|
  | `<leader>Rr` | n | Run/replay the request under cursor *(Default)* |
  | `<leader>Rb` | n | Open scratchpad for ad-hoc requests *(Default)* |
  | `<leader>R` | n | Rest menu (all Kulala commands) *(Default)* |

---

## Python Tooling

- **venv-selector.nvim** (`linux-cultist/venv-selector.nvim`) — Lets you pick which Python virtual environment the LSP and terminal should use for the current project, auto-detecting `venv`/`.venv`/conda environments on disk.

  | Key | Mode | Action |
  |---|---|---|
  | `<leader>cv` | n | Open venv selector *(Default)* |

---

## Custom Plugin — lutos.nvim

This is your own plugin (`sfn101/lutos.nvim`), inspired by the VS Code "Peacock" extension.

**What it does:** Paints a colored vertical bar down the left edge of the editor window, so you can visually tell different projects/workspaces apart at a glance when you have several Neovim windows or tmux panes open side by side — e.g. color your `api` repo blue and your `frontend` repo green, so a stray keystroke in the wrong window is obvious before you even read the file path.

**How it works:** Uses a hybrid rendering approach — it wraps your existing statuscolumn (so diagnostics/git/fold signs are untouched) for the buffer content area, and a shared floating window for any empty space below the last line, so the color bar always covers the full window height. The chosen color is saved per-directory in `~/.local/share/nvim/lutos_state.json` and restored automatically next time you open that project.

**Features:**
- 18 preset colors (including VS Code Peacock's framework-branded colors like "React Blue" and "Vue Green")
- Per-workspace persistence — set once, remembered forever for that directory
- Updates live as you scroll, resize, or edit
- Doesn't interfere with existing sign-column content

| Key | Mode | Action |
|---|---|---|
| `<leader>wp` | n | Open the color picker to paint the current workspace *(Default, from the plugin itself)* |

---

## Color Themes

Pure visual palettes — no interaction needed, just pick one and it applies globally. **`catppuccin` is the currently configured default** (set in `lua/plugins/colorscheme.lua`). Switch anytime with `<leader>uC` (opens a live-preview picker).

| Theme | Style |
|---|---|
| **catppuccin** *(active)* | Soothing pastel palette |
| tokyonight | Clean dark theme, also ships matching Kitty/Alacritty/iTerm/Fish themes |
| kanagawa | Inspired by Hokusai's "The Great Wave" painting |
| rose-pine (`neovim`) | "Soho vibes" — muted, warm |
| nightfox | Highly customizable, multiple variants |
| onedark | Atom's classic One Dark/Light, 5 style variants |
| github-nvim-theme | GitHub's own light/dark editor themes |
| everforest | Comfortable green-toned, low-contrast |
| vscode | Mimics VS Code's Dark+/Light+ |
| cyberdream | High-contrast, futuristic/vibrant |
| onedarkpro | One Dark with Treesitter/LSP semantic tokens |
| material | Google Material palette |
| dracula | The classic purple/dark Dracula theme |
| adwaita | GNOME Adwaita-inspired |
| oxocarbon | IBM Carbon-inspired, written in Fennel |
| solarized-osaka | Dark, clean, Solarized-flavored |
| sonokai | High-contrast, based on Monokai Pro |
| nordic | Nord, but warmer and darker |
| vim-moonfly-colors | Dark charcoal |
| edge | Clean, Atom One/Material inspired |
| tokyodark | Clean minimal dark theme |
| bamboo | Warm green theme |
| melange | Warm, muted tones |
| eldritch | Purple/eldritch-toned dark theme |
| vim-nightfly-colors | Dark midnight blue-toned |
| onenord | Nord + Atom One Dark hybrid |

---

## Custom Keybindings Cheatsheet

Everything below was hand-written for this config (not a plugin or LazyVim default) — the things worth remembering because they're *yours*:

| Key | Mode | What it does | Where |
|---|---|---|---|
| `jj` | insert | Exit to normal mode | `lua/config/keymaps.lua` |
| `<C-s>` | i/x/n/s | Save file; prompts for a filename if the buffer is unnamed | `lua/config/keymaps.lua` |
| `<leader>fw` | n | Save file | `lua/config/keymaps.lua` |
| `<leader>fs` | n | Save file, always prompting for a name | `lua/config/keymaps.lua` |
| `<leader>t` | n | Toggle floating terminal (Snacks) | `lua/config/keymaps.lua` |
| `<Esc>` (in a Snacks terminal) | terminal | Exit terminal mode in one press, instead of the usual `<C-\><C-n>` | `lua/plugins/snacks.lua` |
| `<C-n>` / `<C-x>` | n/v | Multicursor: add / skip-and-advance to next match | `lua/plugins/multicursor.lua` |
| `<C-Up>` / `<C-Down>` | n/v | Multicursor: add cursor on line above/below | `lua/plugins/multicursor.lua` |
| `<C-LeftMouse>` | n | Multicursor: add cursor at click | `lua/plugins/multicursor.lua` |
| `<Tab>` (cmp) | insert | Cmp select-next when menu open, else AI-accept chain | `lua/plugins/cmp.lua` |
| `>` / `<` (quickfix window) | n | Expand/collapse surrounding context per result | `lua/plugins/quicker.lua` |

---

*Generated to reflect the live plugin list and active keymaps captured directly from this Neovim install.*
