local M = {}

local state = require("lutos.state")
local config = require("lutos.config")

-- Available colors (similar to VSCode Peacock defaults)
local COLORS = {
  { name = "Angular Red", color = "#dd0531" },
  { name = "Azure Blue", color = "#007fff" },
  { name = "JavaScript Yellow", color = "#f9e64f" },
  { name = "Mandalorian Blue", color = "#1857a4" },
  { name = "Node Green", color = "#215732" },
  { name = "React Blue", color = "#61dafb" },
  { name = "Something Different", color = "#832561" },
  { name = "Svelte Orange", color = "#ff3d00" },
  { name = "Vue Green", color = "#42b883" },
  { name = "Red", color = "#ff5555" },
  { name = "Green", color = "#50fa7b" },
  { name = "Yellow", color = "#f1fa8c" },
  { name = "Blue", color = "#8be9fd" },
  { name = "Magenta", color = "#ff79c6" },
  { name = "Orange", color = "#ffb86c" },
  { name = "Purple", color = "#bd93f9" },
  { name = "Pink", color = "#ff92df" },
  { name = "None", color = nil }, -- Remove color
}

-- Store mapping of window -> float window for empty space
local empty_space_floats = {}

-- Get current workspace (directory)
local function get_workspace()
  return vim.fn.getcwd()
end

-- Set highlight color for the bar
local function set_bar_highlight(color)
  if color then
    vim.api.nvim_set_hl(0, "LutosBar", { bg = color })
  end
end

-- Create or get buffer for the floating window
local function get_or_create_float_buffer()
  if not M.float_bufnr or not vim.api.nvim_buf_is_valid(M.float_bufnr) then
    M.float_bufnr = vim.api.nvim_create_buf(false, true)
    vim.bo[M.float_bufnr].buftype = "nofile"
    vim.bo[M.float_bufnr].bufhidden = "hide"
    vim.bo[M.float_bufnr].swapfile = false
  end
  return M.float_bufnr
end

-- Fill buffer with colored spaces
local function fill_buffer_with_spaces(bufnr, height, width)
  local lines = {}
  local line = string.rep(" ", width)
  for i = 1, height do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

-- Statuscolumn wrapper that prepends colored bar to Snacks statuscolumn
function M.statuscolumn()
  local workspace = get_workspace()
  local color = state.get_color(workspace)
  local width = config.options.bar_width or 2

  -- Get Snacks statuscolumn output
  local snacks_ok, snacks = pcall(require, "snacks.statuscolumn")
  local snacks_output = ""
  if snacks_ok and snacks.get then
    snacks_output = snacks.get()
  end

  -- If no color set, just return Snacks output
  if not color then
    return snacks_output
  end

  -- Prepend colored bar
  local bar = string.rep(" ", width)
  return "%#LutosBar#" .. bar .. "%*" .. snacks_output
end

-- Update floating window for empty space below buffer content
local function update_empty_space_float(winid)
  if not vim.api.nvim_win_is_valid(winid) then
    return
  end

  local bufnr = vim.api.nvim_win_get_buf(winid)

  -- Skip special buffers
  local buftype = vim.bo[bufnr].buftype
  if buftype ~= "" then
    -- Remove float if exists
    if empty_space_floats[winid] then
      pcall(vim.api.nvim_win_close, empty_space_floats[winid], true)
      empty_space_floats[winid] = nil
    end
    return
  end

  local workspace = get_workspace()
  local color = state.get_color(workspace)
  local width = config.options.bar_width or 2

  -- If no color, remove the float window
  if not color then
    if empty_space_floats[winid] then
      pcall(vim.api.nvim_win_close, empty_space_floats[winid], true)
      empty_space_floats[winid] = nil
    end
    return
  end

  -- Calculate empty space
  local buf_lines = vim.api.nvim_buf_line_count(bufnr)
  local win_height = vim.api.nvim_win_get_height(winid)
  local top_line = vim.fn.line("w0", winid) -- First visible line
  local bot_line = vim.fn.line("w$", winid) -- Last visible line

  -- Calculate how many lines of content are visible
  local visible_content_lines = bot_line - top_line + 1

  -- If buffer has fewer lines than what's visible, there's empty space
  local empty_lines = 0
  if buf_lines < top_line + win_height - 1 then
    -- Empty space exists
    local last_visible_buf_line = math.min(buf_lines, bot_line)
    local content_lines_shown = last_visible_buf_line - top_line + 1
    empty_lines = win_height - content_lines_shown
  end

  if empty_lines > 0 then
    -- Set the highlight
    set_bar_highlight(color)

    -- Get or create buffer
    local float_bufnr = get_or_create_float_buffer()

    -- Fill buffer with spaces
    fill_buffer_with_spaces(float_bufnr, empty_lines, width)

    -- Calculate position: start after last content line
    local row_start = win_height - empty_lines

    local float_config = {
      relative = "win",
      win = winid,
      row = row_start,
      col = 0, -- Left edge, will align with statuscolumn
      width = width,
      height = empty_lines,
      style = "minimal",
      focusable = false,
      zindex = 1,
    }

    -- Create or update float window
    if empty_space_floats[winid] and vim.api.nvim_win_is_valid(empty_space_floats[winid]) then
      -- Update existing float window
      vim.api.nvim_win_set_config(empty_space_floats[winid], float_config)
    else
      -- Create new float window
      local float_winid = vim.api.nvim_open_win(float_bufnr, false, float_config)
      empty_space_floats[winid] = float_winid

      -- Set window options
      vim.wo[float_winid].winhighlight = "Normal:LutosBar"
      vim.wo[float_winid].winblend = 0
    end
  else
    -- No empty space, remove float if it exists
    if empty_space_floats[winid] then
      pcall(vim.api.nvim_win_close, empty_space_floats[winid], true)
      empty_space_floats[winid] = nil
    end
  end
end

-- Apply to all windows
local function apply_to_all_windows()
  -- Clean up invalid mappings
  for winid, float_winid in pairs(empty_space_floats) do
    if not vim.api.nvim_win_is_valid(winid) then
      if vim.api.nvim_win_is_valid(float_winid) then
        pcall(vim.api.nvim_win_close, float_winid, true)
      end
      empty_space_floats[winid] = nil
    end
  end

  -- Update all windows
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    update_empty_space_float(winid)
  end
end

-- Show color picker
local function pick_color()
  local workspace = get_workspace()
  local current_color = state.get_color(workspace)

  -- Build menu items
  local items = {}
  for _, c in ipairs(COLORS) do
    local prefix = (current_color == c.color) and "● " or "  "
    table.insert(items, prefix .. c.name)
  end

  vim.ui.select(items, {
    prompt = "Pick color for workspace: " .. vim.fn.fnamemodify(workspace, ":~"),
  }, function(choice, idx)
    if not choice then
      return
    end

    local selected = COLORS[idx]

    if selected.color then
      print(string.format("Lutos: %s applied to workspace", selected.name))
      state.set_color(workspace, selected.color)
      set_bar_highlight(selected.color)
    else
      print("Lutos: Color removed from workspace")
      state.set_color(workspace, nil)
    end

    -- Trigger refresh
    apply_to_all_windows()
    vim.cmd("redraw")
  end)
end

-- Setup autocmds
local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("Lutos", { clear = true })

  -- Update floats on text changes (lines added/removed)
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWinEnter", "WinEnter" }, {
    group = group,
    callback = function()
      local winid = vim.api.nvim_get_current_win()
      vim.defer_fn(function()
        update_empty_space_float(winid)
      end, 10)
    end,
  })

  -- Update floats on scrolling
  vim.api.nvim_create_autocmd({ "WinScrolled" }, {
    group = group,
    callback = function()
      apply_to_all_windows()
    end,
  })

  -- Update floats on window resize
  vim.api.nvim_create_autocmd({ "WinResized" }, {
    group = group,
    callback = function()
      vim.defer_fn(function()
        apply_to_all_windows()
      end, 10)
    end,
  })

  -- Clean up float when window is closed
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    callback = function(args)
      local closed_winid = tonumber(args.match)
      if closed_winid and empty_space_floats[closed_winid] then
        if vim.api.nvim_win_is_valid(empty_space_floats[closed_winid]) then
          pcall(vim.api.nvim_win_close, empty_space_floats[closed_winid], true)
        end
        empty_space_floats[closed_winid] = nil
      end
    end,
  })

  -- Handle directory changes
  vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function()
      local workspace = get_workspace()
      local color = state.get_color(workspace)
      if color then
        set_bar_highlight(color)
      end
      apply_to_all_windows()
      vim.cmd("redraw")
    end,
  })
end

-- Setup function
function M.setup(opts)
  config.setup(opts or {})
  state.load()

  -- Set statuscolumn to use lutos wrapper
  vim.opt.statuscolumn = [[%!v:lua.require'lutos'.statuscolumn()]]

  -- Apply current workspace color on startup
  local workspace = get_workspace()
  local color = state.get_color(workspace)
  if color then
    set_bar_highlight(color)
  end

  -- Setup autocmds
  setup_autocmds()

  -- Apply to all windows on startup
  vim.defer_fn(function()
    apply_to_all_windows()
  end, 100)

  -- Setup keymaps
  local wk = require("which-key")
  wk.add({
    { "<leader>w", group = "workspace" },
    { "<leader>wp", pick_color, desc = "Paint workspace (lutos color picker)" },
  })
end

return M
