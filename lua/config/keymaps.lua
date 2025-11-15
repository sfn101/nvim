-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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

-- Diagnostics functions
local function show_only_errors()
  require("tiny-inline-diagnostic").change_severities({ vim.diagnostic.severity.ERROR })
end

local function show_only_warnings()
  require("tiny-inline-diagnostic").change_severities({ vim.diagnostic.severity.WARN })
end

local function show_all_diagnostics()
  require("tiny-inline-diagnostic").change_severities({
    vim.diagnostic.severity.ERROR,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.HINT,
  })
end

vim.keymap.set("i", "jj", "<Esc>")

-- Override <C-s> to prompt if untitled
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", function()
  save_with_prompt(false)
end, { desc = "Save File" })

-- Exit terminal mode with ESC (handled by snacks for its terminals)

-- Which-key menu setup
local wk = require("which-key")
wk.add({

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

  {
    "<leader>t",
    function()
      require("snacks").terminal()
    end,
    desc = "Toggle terminal",
  },
})
