-- AlignDelim is simple comand that align selected text by a delimiter

vim.api.nvim_create_user_command('AlignUsingDelim', function()
  -- Prompt for delimiter
  local delim = vim.fn.input 'delim: '
  if delim == '' then
    return
  end

  -- Get visual range
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Find max delimiter position
  local max_col = 0
  for _, line in ipairs(lines) do
    local col = string.find(line, delim, 1, true)
    while col and col > 2 and line:sub(col - 1, col - 1) == ' ' do
      col = col - 1
    end
    if col and col > max_col then
      max_col = col + 1
    end
  end
  -- Align using the must far away delim
  for i, line in ipairs(lines) do
    local start, _end = string.find(line, delim, 1, true)
    while start and start > 2 and line:sub(start - 1, start - 1) == ' ' do
      start = start - 1
    end
    if start and _end then
      lines[i] = line:sub(0, start - 1) .. string.rep(' ', max_col - start) .. delim .. line:sub(_end + 1)
    end
  end

  -- Replace lines in buffer
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end, { range = true })
