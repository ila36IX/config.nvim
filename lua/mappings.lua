-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic quickfix list' })

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Key maps for tab hondler
vim.keymap.set('n', '<leader>l', ':tabnext<CR>', { desc = 'Go to the next tab' })
vim.keymap.set('n', '<leader>h', ':tabprevious<CR>', { desc = 'Go to the previous tab' })

-- Term toggle
vim.keymap.set({ 'n', 't' }, '<A-s>', vim.cmd.TermToggle, { desc = 'Toggle [T]erminal', silent = true })

-- Copy to system clipboard using the + register
vim.keymap.set({ 'v', 'n' }, '<leader>yc', '"+y', { desc = 'Copy into sys-clipboard' })

-- Replace selected text without yanking it
vim.keymap.set({ 'v' }, '<leader>rs', '"_dP', { desc = 'Replace without yanking' })
-- Replace current word with yanked text without yanking it
vim.keymap.set({ 'n' }, '<leader>rw', 'viw"_dP', { desc = 'Copy into sys-clipboard' })

-- Move line Up or Down and respect line indentation
vim.keymap.set({ 'v' }, 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line to top' })
vim.keymap.set({ 'v' }, 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line to buttom' })

-- fix indents once and exits visual mode when using > and <
vim.keymap.set({ 'v' }, '>', '>gv', { desc = 'indent to left' })
vim.keymap.set({ 'v' }, '<', '<gv', { desc = 'indent to right' })

-- Easy buffers navigation
vim.keymap.set({ 'n' }, '<Tab>', ':bn<CR>', { desc = 'Go to the next buffer' })
vim.keymap.set({ 'n' }, '<s-Tab>', ':bp<CR>', { desc = 'Go to the previous buffer' })
vim.keymap.set({ 'n' }, '<C-Space>', ':e#<CR>', { desc = 'Cycle between two previously used buffs' })
vim.keymap.set({ 'n', 'i' }, '<C-b>', '<Esc>:Ex<CR>', { desc = 'Cycle between two previously used buffs' })

-- Easy quickfix navigation
vim.keymap.set({ 'n' }, '<C-j>', ':cn<CR>', { desc = 'Next item in Quickfix' })
vim.keymap.set({ 'n' }, '<C-k>', ':cp<CR>', { desc = 'Previous item in Quickfix' })

-- Quit
vim.keymap.set('n', '<leader>q', ':qall<CR>', { desc = 'Close current tab ans save' })
vim.keymap.set('n', '<leader>Q', ':qall!<CR>', { desc = 'Close current tab ans save' })
vim.keymap.set('n', '<leader>x', ':bd<CR>', { desc = 'Close current buffer' })
vim.keymap.set('n', '<leader>X', ':bd!<CR>', { desc = 'Close current buffer' })
