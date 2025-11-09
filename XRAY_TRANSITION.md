# xray.nvim GitHub Transition

## Status: Configuration Updated ✓

Your Neovim config has been updated to use the GitHub repository `sfn101/xray.nvim` instead of the local directory.

## Current Setup

**Before (local):**
```lua
dir = vim.fn.stdpath("config") .. "/xray.nvim",
```

**After (GitHub):**
```lua
"sfn101/xray.nvim",
```

## Next Steps to Complete Transition

### Option 1: Clean Install (Recommended)

1. **Backup your state** (optional):
   ```bash
   cp ~/.local/share/nvim/xray_state.json ~/xray_state_backup.json
   ```

2. **Remove local xray.nvim directory** (optional, keep as backup):
   ```bash
   mv ~/.config/nvim/xray.nvim ~/.config/nvim/xray.nvim.backup
   ```

3. **Update plugins in Neovim**:
   ```vim
   :Lazy sync
   ```
   
   Or restart Neovim - lazy.nvim will automatically install from GitHub.

4. **Verify installation**:
   ```bash
   ls -la ~/.local/share/nvim/lazy/xray.nvim
   ```
   
   You should see the GitHub clone here.

### Option 2: Gradual Transition

Keep both versions temporarily:

1. Just restart Neovim
2. lazy.nvim will install from GitHub automatically
3. Both local and GitHub versions will exist:
   - Local: `~/.config/nvim/xray.nvim/` (backup)
   - GitHub: `~/.local/share/nvim/lazy/xray.nvim/` (active)

## Verification

After transition, verify xray.nvim is working:

1. **Test a keymap**:
   - Press `gla` to toggle diagnostics

2. **Check plugin source**:
   ```vim
   :Lazy
   ```
   Look for `xray.nvim` - it should show the GitHub URL

3. **Check state persistence**:
   ```bash
   cat ~/.local/share/nvim/xray_state.json
   ```

## Benefits of GitHub Installation

✅ **Automatic updates**: Run `:Lazy sync` to get latest version
✅ **Standard workflow**: Matches other plugins
✅ **Community access**: Others can use your plugin
✅ **Version control**: Easy to track changes and rollback
✅ **Clean separation**: Config and plugin are separate

## Rollback (if needed)

To rollback to local version:

1. Edit `lua/plugins/xray.lua`:
   ```lua
   dir = vim.fn.stdpath("config") .. "/xray.nvim",
   ```

2. Restart Neovim

## Files Updated

- ✅ `lua/plugins/xray.lua` - Changed to GitHub URL
- ✅ `AGENTS.md` - Updated documentation
- ✅ `README.md` - Added GitHub repository link

## Your State File

Your diagnostic settings are stored separately and will persist:
- **Location**: `~/.local/share/nvim/xray_state.json`
- **Preserved**: All your current settings (modes, enabled states, focus default)
- **Safe**: Not affected by plugin source change

---

**Current config status**: Ready for GitHub installation
**Next action**: Restart Neovim or run `:Lazy sync`
