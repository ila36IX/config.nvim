-- Get the class name from the user and open two files in seperete tab
-- the header in the left and the class in the right

-- check if file exists in the tab
local function file_in_tab(tab, name)
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    local bname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
    if vim.fn.fnamemodify(bname, ':t') == name then
      return true
    end
  end
  return false
end

-- Switch to selected tab
-- it will create one if not already exists
local switch_tab = function(selected)
  if selected then
    local cpp = selected .. '.cpp'
    local h = selected .. '.h'

    -- if tab exists, jump and ensure layout
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      local ok, id = pcall(vim.api.nvim_tabpage_get_var, tab, 'class_id')
      if ok and id == selected then
        vim.api.nvim_set_current_tabpage(tab)
        if not file_in_tab(tab, cpp) then
          vim.cmd.edit(cpp)
        end
        if not file_in_tab(tab, h) then
          vim.cmd.vsplit(h)
        end
        return
      end
    end

    -- else create tab and set layout
    vim.cmd.tabnew()
    vim.api.nvim_tabpage_set_var(0, 'class_id', selected)
    vim.cmd.edit(cpp)
    vim.cmd.vsplit(h)
  end
end

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
  }, switch_tab)
end

vim.api.nvim_create_user_command('ClassOpen', openClassInTab, {})
