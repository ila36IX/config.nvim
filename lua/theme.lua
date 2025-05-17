local M = {}

local theme_file = vim.fn.stdpath 'config' .. '/.theme'

function M.save(theme)
  local f = io.open(theme_file, 'w')
  if f then
    f:write(theme)
    f:close()
  end
end

function M.load()
  local f = io.open(theme_file, 'r')
  if f then
    local theme = f:read '*l'
    f:close()
    return theme
  end
  return 'vim'
end

return M
