-- newtree configs

vim.g.netrw_banner = 0 -- delete the banner

-- Show directories first (sorting)
vim.g.netrw_sort_sequence = [[[\/]$,*]]

-- Human-readable files sizes
vim.g.netrw_sizestyle = 'H'

-- list style (to be tree like)
vim.g.netrw_liststyle = 3

if package.config:sub(1, 1) == '/' then
  vim.g.netrw_localcopydircmd = 'cp -r' -- Enable recursive copy of directories in *nix systems
  vim.g.netrw_localmkdir = 'mkdir -p' -- Enable recursive creation of directories in *nix systems
  vim.g.netrw_localrmdir = 'rm -r' -- Enable recursive removal of directories in *nix systems
end

-- Open in left (it intended to be the first buffer)
vim.keymap.set('n', '<leader>b', function()
  vim.cmd.Lexplore()
  vim.cmd 'vertical resize 30'
end, { desc = '[O]pen file Explorer in left' })

-- Launch tree-navigation
-- "gh" command hide gitignore files
vim.keymap.set({ 'n', 'i' }, '<C-b>', '<Esc>:Ex<CR>', { desc = 'Cycle between two previously used buffs' })
