return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")

    mc.setup()

    -- VS Code-like mappings
    -- Select word under cursor (Ctrl + n) - press again for next occurrence
    vim.keymap.set({ "n", "v" }, "<C-n>", function() mc.matchAddCursor(1) end)

    -- Skip current match (Ctrl + x) - like VS Code's Ctrl+K Ctrl+D
    vim.keymap.set({ "n", "v" }, "<C-x>", function() mc.deleteCursor() mc.matchAddCursor(1) end)

    -- Add cursor Up/Down (Ctrl + Up/Down)
    vim.keymap.set({ "n", "v" }, "<C-Up>", function() mc.lineAddCursor(-1) end)
    vim.keymap.set({ "n", "v" }, "<C-Down>", function() mc.lineAddCursor(1) end)

    -- Mouse support: Ctrl + Left Click to add a cursor
    vim.keymap.set("n", "<C-LeftMouse>", mc.handleMouse)

    -- Cancel/Clear cursors (Esc)
    vim.keymap.set("n", "<Esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      else
        -- Default <Esc> behavior if no cursors exist
        vim.cmd("noh") -- Clear highlights
      end
    end)
  end,
}