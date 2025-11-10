local M = {}

M.options = {
  state_file = vim.fn.stdpath("data") .. "/lutos_state.json",
  bar_width = 2, -- Width of the colored bar in characters
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
