return {
  "folke/lazy.nvim",
  priority = 1000,
  init = function()
    -- Path to store persistent state
    local state_file = vim.fn.stdpath("data") .. "/xray_state.json"

    -- Load saved state or use defaults
    local function load_state()
      local file = io.open(state_file, "r")
      if file then
        local content = file:read("*all")
        file:close()
        local ok, state = pcall(vim.json.decode, content)
        if ok and state then
          return state
        end
      end
      -- Default: all severities enabled and in text mode, focus mode off
      return {
        modes = {
          ERROR = true,
          WARN = true,
          INFO = true,
          HINT = true,
        },
        enabled = {
          ERROR = true,
          WARN = true,
          INFO = true,
          HINT = true,
        },
        focus_default = false,
      }
    end

    local loaded_state = load_state()
    
    -- Helper to safely get boolean value with default, supports both old numeric keys and new string labels
    local function get_bool(table, key, numeric_key, default)
      if table then
        if table[key] ~= nil then
          return table[key]
        end
        if table[tostring(numeric_key)] ~= nil then
          return table[tostring(numeric_key)]
        end
      end
      return default
    end
    
    -- Track display mode for each severity: true = text, false = lines
    local severity_modes = {
      [vim.diagnostic.severity.ERROR] = get_bool(loaded_state.modes, "ERROR", vim.diagnostic.severity.ERROR, get_bool(loaded_state, "ERROR", vim.diagnostic.severity.ERROR, true)),
      [vim.diagnostic.severity.WARN] = get_bool(loaded_state.modes, "WARN", vim.diagnostic.severity.WARN, get_bool(loaded_state, "WARN", vim.diagnostic.severity.WARN, true)),
      [vim.diagnostic.severity.INFO] = get_bool(loaded_state.modes, "INFO", vim.diagnostic.severity.INFO, get_bool(loaded_state, "INFO", vim.diagnostic.severity.INFO, true)),
      [vim.diagnostic.severity.HINT] = get_bool(loaded_state.modes, "HINT", vim.diagnostic.severity.HINT, get_bool(loaded_state, "HINT", vim.diagnostic.severity.HINT, true)),
    }
    
    -- Track whether each severity is enabled: true = shown, false = hidden
    local severity_enabled = {
      [vim.diagnostic.severity.ERROR] = get_bool(loaded_state.enabled, "ERROR", vim.diagnostic.severity.ERROR, true),
      [vim.diagnostic.severity.WARN] = get_bool(loaded_state.enabled, "WARN", vim.diagnostic.severity.WARN, true),
      [vim.diagnostic.severity.INFO] = get_bool(loaded_state.enabled, "INFO", vim.diagnostic.severity.INFO, true),
      [vim.diagnostic.severity.HINT] = get_bool(loaded_state.enabled, "HINT", vim.diagnostic.severity.HINT, true),
    }

    -- Focus mode state
    local focus_mode = false
    local focus_default = loaded_state.focus_default or false
    local focus_namespace = vim.api.nvim_create_namespace('diagnostic_focus')
    local focus_autocmd = nil

    -- Save current state to disk
    local function save_state()
      -- Use descriptive labels instead of numeric codes
      local state = {
        modes = {
          ERROR = severity_modes[vim.diagnostic.severity.ERROR],
          WARN = severity_modes[vim.diagnostic.severity.WARN],
          INFO = severity_modes[vim.diagnostic.severity.INFO],
          HINT = severity_modes[vim.diagnostic.severity.HINT],
        },
        enabled = {
          ERROR = severity_enabled[vim.diagnostic.severity.ERROR],
          WARN = severity_enabled[vim.diagnostic.severity.WARN],
          INFO = severity_enabled[vim.diagnostic.severity.INFO],
          HINT = severity_enabled[vim.diagnostic.severity.HINT],
        },
        focus_default = focus_default,
      }
      local file = io.open(state_file, "w")
      if file then
        file:write(vim.json.encode(state))
        file:close()
      end
    end

    local function update_display()
      local text_severities = {}
      local line_severities = {}

      -- Build arrays based on each severity's mode and enabled state
      for severity, is_text_mode in pairs(severity_modes) do
        if severity_enabled[severity] then
          if is_text_mode then
            table.insert(text_severities, severity)
          else
            table.insert(line_severities, severity)
          end
        end
      end

      vim.diagnostic.config({
        underline = true,
        virtual_text = #text_severities > 0 and {
          severity = text_severities,
        } or false,
        virtual_lines = #line_severities > 0 and {
          severity = line_severities,
        } or false,
      })

      -- Refresh diagnostics for all buffers
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
          vim.diagnostic.hide(nil, bufnr)
          vim.diagnostic.show(nil, bufnr)
        end
      end
    end

    -- Focus mode functions (defined early so they can be called by other functions)
    local function update_focus_diagnostics()
      if not focus_mode then
        return
      end
      
      local bufnr = vim.api.nvim_get_current_buf()
      local line = vim.api.nvim_win_get_cursor(0)[1] - 1
      
      -- Get all diagnostics for current buffer
      local all_diagnostics = vim.diagnostic.get(bufnr)
      
      -- Filter diagnostics for current line only, respecting enabled state
      local line_diagnostics = {}
      for _, diagnostic in ipairs(all_diagnostics) do
        if diagnostic.lnum == line and severity_enabled[diagnostic.severity] then
          table.insert(line_diagnostics, diagnostic)
        end
      end
      
      -- Clear previous focus diagnostics and show only current line
      vim.diagnostic.reset(focus_namespace, bufnr)
      if #line_diagnostics > 0 then
        vim.diagnostic.set(focus_namespace, bufnr, line_diagnostics, {})
      end
    end

    local function exit_focus_mode()
      if not focus_mode then
        return
      end
      
      focus_mode = false
      
      -- Remove autocmd
      if focus_autocmd then
        vim.api.nvim_del_autocmd(focus_autocmd)
        focus_autocmd = nil
      end
      
      -- Clear focus namespace
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
          vim.diagnostic.reset(focus_namespace, bufnr)
        end
      end
    end

    local function toggle_focus_mode()
      focus_mode = not focus_mode
      
      if focus_mode then
        -- Enable focus mode
        -- Build config respecting current severity modes
        local text_severities = {}
        local line_severities = {}
        
        for severity, is_text_mode in pairs(severity_modes) do
          if severity_enabled[severity] then
            if is_text_mode then
              table.insert(text_severities, severity)
            else
              table.insert(line_severities, severity)
            end
          end
        end
        
        -- Hide global diagnostics completely
        vim.diagnostic.config({
          underline = true,
          virtual_text = false,
          virtual_lines = false,
        })
        
        -- Set up focus namespace with the same text/line settings
        vim.diagnostic.config({
          underline = true,
          virtual_text = #text_severities > 0 and {
            severity = text_severities,
          } or false,
          virtual_lines = #line_severities > 0 and {
            severity = line_severities,
          } or false,
        }, focus_namespace)
        
        -- Create autocmd to update on cursor movement
        focus_autocmd = vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
          callback = update_focus_diagnostics,
        })
        
        -- Initial update
        update_focus_diagnostics()
        print("Focus mode: ON (showing diagnostics only on current line)")
      else
        -- Disable focus mode
        exit_focus_mode()
        
        -- Restore normal display
        update_display()
        print("Focus mode: OFF")
      end
    end

    local function toggle_focus_default()
      focus_default = not focus_default
      print(string.format("Focus mode default: %s (will apply on next startup)", focus_default and "ON" or "OFF"))
      save_state()
    end

    local function toggle_severity(severity, name)
      return function()
        -- Exit focus mode if active
        exit_focus_mode()
        
        -- If hidden, show it first before toggling mode
        if not severity_enabled[severity] then
          severity_enabled[severity] = true
          print(string.format("Showing %s", name))
        end
        severity_modes[severity] = not severity_modes[severity]
        print(string.format("Toggled %s, text_mode = %s", name, tostring(severity_modes[severity])))
        save_state() -- Save after each toggle
        update_display()
      end
    end

    local function reset_to_default()
      -- Exit focus mode if active
      exit_focus_mode()
      
      -- Reset all severities to virtual text mode (default)
      severity_modes[vim.diagnostic.severity.ERROR] = true
      severity_modes[vim.diagnostic.severity.WARN] = true
      severity_modes[vim.diagnostic.severity.INFO] = true
      severity_modes[vim.diagnostic.severity.HINT] = true
      severity_enabled[vim.diagnostic.severity.ERROR] = true
      severity_enabled[vim.diagnostic.severity.WARN] = true
      severity_enabled[vim.diagnostic.severity.INFO] = true
      severity_enabled[vim.diagnostic.severity.HINT] = true
      print("Reset all severities to virtual text mode")
      save_state()
      update_display()
    end

    local function toggle_error()
      -- Exit focus mode if active
      exit_focus_mode()
      
      severity_enabled[vim.diagnostic.severity.ERROR] = not severity_enabled[vim.diagnostic.severity.ERROR]
      print(string.format("Error diagnostics: %s", severity_enabled[vim.diagnostic.severity.ERROR] and "ON" or "OFF"))
      save_state()
      update_display()
    end

    local function toggle_warnings()
      -- Exit focus mode if active
      exit_focus_mode()
      
      local new_state = not severity_enabled[vim.diagnostic.severity.WARN]
      severity_enabled[vim.diagnostic.severity.WARN] = new_state
      severity_enabled[vim.diagnostic.severity.INFO] = new_state
      severity_enabled[vim.diagnostic.severity.HINT] = new_state
      print(string.format("Warn/Info/Hint diagnostics: %s", new_state and "ON" or "OFF"))
      save_state()
      update_display()
    end

    local function toggle_all()
      -- If focus mode is active, exit and show everything first
      if focus_mode then
        exit_focus_mode()
        severity_enabled[vim.diagnostic.severity.ERROR] = true
        severity_enabled[vim.diagnostic.severity.WARN] = true
        severity_enabled[vim.diagnostic.severity.INFO] = true
        severity_enabled[vim.diagnostic.severity.HINT] = true
        print("All diagnostics: ON")
        save_state()
        update_display()
        return
      end
      
      -- Exit focus mode if active (shouldn't happen but safety check)
      exit_focus_mode()
      
      -- Check if all enabled states are equal
      local all_same = severity_enabled[vim.diagnostic.severity.ERROR] == severity_enabled[vim.diagnostic.severity.WARN]
        and severity_enabled[vim.diagnostic.severity.WARN] == severity_enabled[vim.diagnostic.severity.INFO]
        and severity_enabled[vim.diagnostic.severity.INFO] == severity_enabled[vim.diagnostic.severity.HINT]
      
      local new_state
      if all_same then
        -- All are equal, toggle them
        new_state = not severity_enabled[vim.diagnostic.severity.ERROR]
      else
        -- Not all equal, make them all on first
        new_state = true
      end
      
      severity_enabled[vim.diagnostic.severity.ERROR] = new_state
      severity_enabled[vim.diagnostic.severity.WARN] = new_state
      severity_enabled[vim.diagnostic.severity.INFO] = new_state
      severity_enabled[vim.diagnostic.severity.HINT] = new_state
      print(string.format("All diagnostics: %s", new_state and "ON" or "OFF"))
      save_state()
      update_display()
    end

    -- Apply loaded state on startup with delay to ensure LSP is ready
    vim.defer_fn(function()
      if focus_default then
        toggle_focus_mode()
      else
        update_display()
      end
    end, 100) -- 100ms delay

    local wk = require("which-key")
    wk.add({
      { "gl", group = "diagnostics" },
      { "gla", toggle_all, desc = "Toggle all diagnostics on/off" },
      { "gle", toggle_error, desc = "Toggle error on/off" },
      { "glw", toggle_warnings, desc = "Toggle warn/info/hint on/off" },
      { "glf", toggle_focus_mode, desc = "Toggle focus mode (current line only)" },
      { "glse", toggle_severity(vim.diagnostic.severity.ERROR, "ERROR"), desc = "Toggle error display mode" },
      { "glsw", toggle_severity(vim.diagnostic.severity.WARN, "WARN"), desc = "Toggle warn display mode" },
      { "glsi", toggle_severity(vim.diagnostic.severity.INFO, "INFO"), desc = "Toggle info display mode" },
      { "glsh", toggle_severity(vim.diagnostic.severity.HINT, "HINT"), desc = "Toggle hint display mode" },
      { "glsc", reset_to_default, desc = "Reset all to virtual text" },
      { "glsf", toggle_focus_default, desc = "Toggle focus mode as default on startup" },
    })
  end,
}
