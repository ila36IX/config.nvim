-- newtree configs

vim.g.netrw_banner = 0 -- delete the banner

-- Show directories first (sorting)
vim.g.netrw_sort_sequence = [[[\/]$,*]]

-- Human-readable files sizes
vim.g.netrw_sizestyle = 'H'

-- list style (to be tree like)
-- vim.g.netrw_liststyle = 2
vim.g.netrw_liststyle = 0

if package.config:sub(1, 1) == '/' then
  vim.g.netrw_localcopydircmd = 'cp -r' -- Enable recursive copy of directories in *nix systems
  vim.g.netrw_localmkdir = 'mkdir -p' -- Enable recursive creation of directories in *nix systems
  vim.g.netrw_localrmdir = 'rm -r' -- Enable recursive removal of directories in *nix systems
end

-- Launch tree-navigation
-- "gh" command hide gitignore files
vim.keymap.set({ 'n', 'i' }, '<C-b>', '<Esc>:Ex<CR>', { desc = 'Open file tree' })
