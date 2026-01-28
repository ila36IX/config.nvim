-- Get the class name from the user and open two files in seperete tab
-- the header in the left and the class in the right

local openClassInTab = function()
  -- Get all .h files in the current directory as a list
  local files = vim.fn.glob('*.h', false, true)

  -- Process the list to remove the '.h' extension
  local classes = {}
  for _, file in ipairs(files) do
    -- removes the last extension
    table.insert(classes, vim.fn.fnamemodify(file, ':r'))
    -- local name = string.match(input, '[^%.]+') -- Match until first dot
  end
  -- UI picker
  vim.ui.select(classes, {
    prompt = 'Select Class',
  }, function(selected)
    if selected then
      -- Check if a tab with this class_id already exists
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        local success, id = pcall(vim.api.nvim_tabpage_get_var, tab, 'class_id')
        if success and id == selected then
          vim.api.nvim_set_current_tabpage(tab) -- Switch to existing tab
          return
        end
      end
      vim.cmd.tabnew()
      vim.api.nvim_tabpage_set_var(0, 'class_id', selected) -- Set the ID
      vim.cmd.edit(selected .. '.cpp')
      vim.cmd.vsplit(selected .. '.h')
    end
  end)
end

vim.api.nvim_create_user_command('ClassOpen', openClassInTab, {})
