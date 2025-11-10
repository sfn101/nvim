local M = {}

local config = require("lutos.config")

-- State: workspace path -> color mapping
M.workspace_colors = {}

-- Load saved state from disk
function M.load()
  local state_file = config.options.state_file
  local file = io.open(state_file, "r")

  if file then
    local content = file:read("*all")
    file:close()
    local ok, state = pcall(vim.json.decode, content)
    if ok and state and type(state) == "table" then
      M.workspace_colors = state
    end
  end
end

-- Save current state to disk
function M.save()
  local state_file = config.options.state_file
  local file = io.open(state_file, "w")

  if file then
    file:write(vim.json.encode(M.workspace_colors))
    file:close()
  end
end

-- Get color for workspace
function M.get_color(workspace)
  return M.workspace_colors[workspace]
end

-- Set color for workspace
function M.set_color(workspace, color)
  if color == nil then
    M.workspace_colors[workspace] = nil
  else
    M.workspace_colors[workspace] = color
  end
  M.save()
end

return M
