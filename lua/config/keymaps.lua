-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local float_term, fs_term

-- Custom save function that prompts for name if untitled or force_prompt
local function save_with_prompt(force_prompt)
  force_prompt = force_prompt or false
  if force_prompt or vim.fn.bufname() == "" then
    vim.ui.input({ prompt = "Save as: " }, function(input)
      if input and input ~= "" then
        vim.cmd("w " .. vim.fn.fnameescape(input))
      end
    end)
  else
    vim.cmd("w")
  end
end

-- Terminal management functions
local Terminal = require("toggleterm.terminal").Terminal

-- Get all open normal terminal windows (exclude float and fullscreen)
local function get_terminal_windows()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "filetype") == "toggleterm" then
      local name = vim.api.nvim_buf_get_name(buf)
      local id = name:match("toggleterm#(%d+)")
      if id and id ~= "99" and id ~= "98" then
        table.insert(wins, { win = win, id = tonumber(id) })
      end
    end
  end
  table.sort(wins, function(a, b)
    return a.id < b.id
  end)
  return wins
end

-- Cycle to next or previous terminal window
local function cycle_to_terminal(direction)
  local term_wins = get_terminal_windows()
  if #term_wins == 0 then
    return
  end
  local current_win = vim.api.nvim_get_current_win()
  local current_index = nil
  for i, tw in ipairs(term_wins) do
    if tw.win == current_win then
      current_index = i
      break
    end
  end
  local next_index
  if current_index then
    if direction == "next" then
      next_index = current_index % #term_wins + 1
    else
      next_index = (current_index - 2) % #term_wins + 1
    end
  else
    -- Not in terminal, go to first
    next_index = 1
  end
  vim.api.nvim_set_current_win(term_wins[next_index].win)
end

-- Create and toggle a new terminal
local function new_term()
  local term = Terminal:new()
  term:toggle()
end

-- Navigation functions
local prev_term = function()
  cycle_to_terminal("prev")
end
local next_term = function()
  cycle_to_terminal("next")
end

local function toggle_all_terms()
  local normal_bufs = {}
  local windows_to_close = 0
  local any_open = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "filetype") == "toggleterm" then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if not (bufname:match("toggleterm#99") or bufname:match("toggleterm#98")) then
        table.insert(normal_bufs, buf)
        -- Check if this buf has a window
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == buf then
            any_open = true
            windows_to_close = windows_to_close + 1
            break
          end
        end
      end
    end
  end

  if any_open then
    -- Hide all by closing windows, but only if it won't close the last window
    if #vim.api.nvim_list_wins() > windows_to_close then
      for _, buf in ipairs(normal_bufs) do
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == buf then
            vim.api.nvim_win_close(win, false)
          end
        end
      end
    end
  elseif #normal_bufs > 0 then
    -- Show all by opening terminals
    for _, buf in ipairs(normal_bufs) do
      local bufname = vim.api.nvim_buf_get_name(buf)
      local id = bufname:match("toggleterm#(%d+)")
      if id then
        vim.cmd("ToggleTerm " .. id)
      end
    end
  else
    -- Create first terminal
    local term = Terminal:new()
    term:toggle()
  end
end

local function toggle_float()
  if not float_term then
    float_term = Terminal:new({ direction = "float", id = 99 })
  end
  float_term:toggle()
end

local function toggle_fullscreen()
  if not fs_term then
    fs_term = Terminal:new({ direction = "tab", id = 98 })
  end
  fs_term:toggle()
end

local function kill_current_terminal()
  -- Close the current terminal buffer if we're in one
  if vim.api.nvim_buf_get_option(0, "filetype") == "toggleterm" then
    vim.api.nvim_buf_delete(0, { force = true })
  end
end

local function kill_all_terminals()
  -- Close all normal terminal buffers (exclude float and fullscreen)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "filetype") == "toggleterm" then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if not (bufname:match("toggleterm#99") or bufname:match("toggleterm#98")) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
end

local function kill_all_special_terminals()
  -- Close all terminal buffers (normals and special included)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "filetype") == "toggleterm" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

vim.keymap.set("i", "jj", "<Esc>")

-- Override <C-s> to prompt if untitled
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", function()
  save_with_prompt(false)
end, { desc = "Save File" })

-- Which-key menu setup
local wk = require("which-key")
wk.add({
  -- Terminal controls
  { "<leader>j", group = "terminal" },
  { "<leader>jj", toggle_all_terms, desc = "Toggle all terminals (or create first)" },
  { "<leader>jn", new_term, desc = "New terminal" },
  { "<leader>jk", kill_current_terminal, desc = "Kill current terminal" },
  { "<leader>jK", kill_all_terminals, desc = "Kill all normal terminals" },
  { "<leader>j*", kill_all_special_terminals, desc = "Kill all terminals (normals and special)" },
  { "<leader>jf", toggle_float, desc = "Toggle float terminal" },
  { "<leader>jF", toggle_fullscreen, desc = "Toggle fullscreen terminal" },
  { "<leader>j=", "<cmd>resize +5<CR>", desc = "Increase terminal height" },
  { "<leader>j-", "<cmd>resize -5<CR>", desc = "Decrease terminal height" },
  { "<leader>j\\", "<cmd>vertical resize +5<CR>", desc = "Increase terminal width" },
  { "<leader>j|", "<cmd>vertical resize -5<CR>", desc = "Decrease terminal width" },

  -- File controls
  { "<leader>f", group = "file" },
  {
    "<leader>fw",
    function()
      save_with_prompt(false)
    end,
    desc = "Save file",
  },
  {
    "<leader>fs",
    function()
      save_with_prompt(true)
    end,
    desc = "Save file as",
  },

  -- Navigation controls
  { "[", group = "navigation" },
  { "[j", prev_term, desc = "Previous terminal" },
  { "]", group = "navigation" },
  { "]j", next_term, desc = "Next terminal" },
})
