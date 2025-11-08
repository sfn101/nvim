local function cycle_term(direction)
  local current_buf = vim.api.nvim_get_current_buf()
  local current_name = vim.api.nvim_buf_get_name(current_buf)
  local current_id = current_name:match("toggleterm#(%d+)")
  if current_id then
    current_id = tonumber(current_id)
    -- Find all normal terminal ids
    local ids = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "filetype") == "toggleterm" then
        local name = vim.api.nvim_buf_get_name(buf)
        local id = name:match("toggleterm#(%d+)")
        if id and id ~= "99" and id ~= "98" then -- exclude float and full
          table.insert(ids, tonumber(id))
        end
      end
    end
    table.sort(ids)
    local current_index = nil
    for i, id in ipairs(ids) do
      if id == current_id then
        current_index = i
        break
      end
    end
    if current_index then
      local next_index = direction == "next" and ((current_index - 1) % #ids) + 1
        or ((current_index - 1 - 1) % #ids) + 1
      local next_id = ids[next_index]
      vim.cmd("ToggleTerm " .. next_id)
    end
  end
end

_G.cycle_term = cycle_term

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15, -- horizontal half window
        open_mapping = nil, -- disable default mapping to avoid conflicts
        hide_numbers = true,
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = false, -- disable to avoid conflicts
        terminal_mappings = false, -- disable to avoid conflicts
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 3,
        },
        on_open = function(term)
          -- Exit terminal mode with ESC
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
          -- Size control mappings
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<leader>j=", [[<C-\><C-n>:resize +5<CR>i]], { noremap = true })
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<leader>j-", [[<C-\><C-n>:resize -5<CR>i]], { noremap = true })
          vim.api.nvim_buf_set_keymap(
            term.bufnr,
            "t",
            "<leader>j\\",
            [[<C-\><C-n>:vertical resize +5<CR>i]],
            { noremap = true }
          )
          vim.api.nvim_buf_set_keymap(
            term.bufnr,
            "t",
            "<leader>j|",
            [[<C-\><C-n>:vertical resize -5<CR>i]],
            { noremap = true }
          )
        end,
      })
    end,
  },
}
