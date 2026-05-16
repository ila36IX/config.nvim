-- Get the class name from the user and open two files in seperete tab
-- the header in the left and the class in the right

local function open_class_in_tab()
  -- Collect all header files and strip extensions
  local files = vim.fn.glob('**/*.h', false, true)
  vim.list_extend(files, vim.fn.glob('**/*.hpp', false, true))
  -- delete the extension
  local classes = vim.tbl_map(function(f)
    return vim.fn.fnamemodify(f, ':r')
  end, files)

  vim.ui.select(classes, { prompt = 'Select Class' }, function(selected)
    if not selected then
      return
    end

    local h = vim.fn.filereadable(selected .. '.hpp') == 1 and selected .. '.hpp' or selected .. '.h'
    local cpp = selected .. '.cpp'

    -- Reuse existing tab if it matches
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      local ok, id = pcall(vim.api.nvim_tabpage_get_var, tab, 'class_id')
      if ok and id == selected then
        vim.api.nvim_set_current_tabpage(tab)
        -- Check if file is already open in any window of this tab
        local function in_tab(path)
          local abs = vim.fn.fnamemodify(path, ':p')
          return vim.iter(vim.api.nvim_tabpage_list_wins(tab)):any(function(w)
            return vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w)) == abs
          end)
        end
        if not in_tab(cpp) then
          vim.cmd.edit(cpp)
        end
        if not in_tab(h) then
          vim.cmd.vsplit(h)
        end
        return
      end
    end

    -- Create a new tab with the split layout
    vim.cmd.tabnew()
    vim.api.nvim_tabpage_set_var(0, 'class_id', selected)
    vim.cmd.edit(cpp)
    vim.cmd.vsplit(h)
  end)
end

vim.api.nvim_create_user_command('ClassOpen', open_class_in_tab, {})
