-- Execute in the fly
-- TLDR;
--    Setcmd   : Set the friend command
--    leader+e : Run the friend command
--    leader+k : Force stop friend command
--    leader+rn: input command and run it

-- Create the Setcmd command to replace the current command
-- that executed when leader+e
vim.g.cmd_to_run = ''
vim.api.nvim_create_user_command('Setcmd', function()
  local cmd = vim.fn.input('Cmd: ', '', 'shellcmd')
  vim.g.cmd_to_run = cmd
end, {})

-- Read command from the user and execute it
-- Next time will run the same command
-- Use Setcmd to replace it
vim.keymap.set('n', '<leader>e', function()
  local cmd
  if vim.g.cmd_to_run == '' then
    cmd = vim.fn.input('Run: ', '', 'shellcmd')
    vim.g.cmd_to_run = cmd
  else
    cmd = vim.g.cmd_to_run
  end
  if cmd ~= '' then
    vim.cmd('horizontal terminal ' .. cmd)
    vim.cmd 'set number'
  end
end, { desc = 'Run saved command' })

-- Execute in the fly
-- Read command from the user and execute it
-- vim.keymap.set('n', '<leader>rn', function()
--   local cmd
--   cmd = vim.fn.input('Run: ', '', 'shellcmd')
--   if cmd ~= '' then
--     vim.cmd('horizontal terminal ' .. cmd)
--     vim.cmd 'set number'
--   end
-- end, { desc = 'Run the giving command' })
vim.keymap.set('n', '<leader>rn', ':botright new | term ', { desc = 'Run the giving command' })

-- Force stopping command execution
vim.keymap.set({ 'n' }, '<leader>k', function()
  local ok, job_id = pcall(function()
    return vim.b.terminal_job_id
  end)

  if ok and job_id and job_id > 0 then
    vim.fn.chansend(job_id, '\003') -- \003 is Ctrl-C
  end
end, { desc = 'Kill process' })
