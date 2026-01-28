-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setqflist, { desc = '[D]iagnostics qflist' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = '[D]iagnostics [N]ext' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = '[D]iagnostics [P]rev' })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = '[D]iagnostics [D]etails' })

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Key maps for tab hondler
vim.keymap.set('n', '<C-h>', ':tabnext<CR>', { desc = 'Go to the next tab' })
vim.keymap.set('n', '<C-l>', ':tabprevious<CR>', { desc = 'Go to the previous tab' })

-- Term toggle
vim.keymap.set({ 'n', 't' }, '<A-s>', vim.cmd.TermToggle, { desc = 'Toggle [T]erminal', silent = true })

-- Copy to system clipboard using the + register
vim.keymap.set({ 'v', 'n' }, '<leader>yc', '"+y', { desc = 'Copy into sys-clipboard' })
vim.keymap.set({ 'v', 'n' }, '<C-c>', '"+y', { desc = 'Copy into sys-clipboard' })

-- Replace selected text without yanking it
vim.keymap.set({ 'v' }, '<leader>rs', '"_dP', { desc = 'Replace seleceted with no yank' })
-- Replace current word with yanked text without yanking it
vim.keymap.set({ 'n' }, '<leader>rw', 'viw"_dP', { desc = 'Replace currword with no yank' })

-- Move line Up or Down and respect line indentation
vim.keymap.set({ 'v' }, 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line to top' })
vim.keymap.set({ 'v' }, 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line to buttom' })

-- fix indents once and exits visual mode when using > and <
vim.keymap.set({ 'v' }, '>', '>gv', { desc = 'indent to left' })
vim.keymap.set({ 'v' }, '<', '<gv', { desc = 'indent to right' })

-- Easy buffers navigation
vim.keymap.set({ 'n' }, '<Tab>', ':bn<CR>', { desc = 'Go to the next buffer' })
vim.keymap.set({ 'n' }, '<s-Tab>', ':bp<CR>', { desc = 'Go to the previous buffer' })
vim.keymap.set({ 'n' }, '<C-Space>', ':e#<CR>', { desc = 'Cycle between two buffers' })

-- Launch tree-navigation and make "gh" command hide gitignore files
vim.keymap.set({ 'n', 'i' }, '<C-b>', '<Esc>:Ex<CR>', { desc = 'Open the files tree' })

-- Easy quickfix navigation
vim.keymap.set({ 'n' }, '<C-Down>', ':cn<CR>', { desc = 'Next item in Quickfix' })
vim.keymap.set({ 'n' }, '<C-Up>', ':cp<CR>', { desc = 'Previous item in Quickfix' })

-- Quiting
vim.keymap.set('n', '<leader>q', ':qall<CR>', { desc = 'Close current tab ans save' })
vim.keymap.set('n', '<leader>Q', ':qall!<CR>', { desc = 'Close current tab ans save' })
vim.keymap.set('n', '<leader>x', ':bd<CR>', { desc = 'Close current buffer' })
vim.keymap.set('n', '<leader>X', ':bd!<CR>', { desc = 'Close current buffer' })

-- Run the make program and fill Quickfix with errors if found
vim.keymap.set({ 'n' }, '<leader>m', vim.cmd.make, { desc = 'Make using makeprg' })

vim.keymap.set({ 'n' }, '<leader>gs', ':Telescope git_status<CR>', { desc = '[g]it status' })

function insert_new_cpp_class()
  local className = vim.fn.input 'Class name: '
  if className == '' then
    return
  end

  local format = [[
class A
{
    public:
        A(void);
        A(/* Parameters */);
        A(const A &other);
        A &operator=(const A &other);
        ~A();
};

A::A(void)
{
}

A::A(/*parameters*/)
{
}

A::A(const A &other)
{
    *this = other;
}

A &A::operator=(const A &other)
{
    if (this != &other)
    {
        // _member = other._member;
    }
    return (*this);
}

A::~A()
{
}
]]
  local classCode = string.gsub(format, 'A', className)
  local lines = vim.split(classCode, '\n')
  vim.api.nvim_put(lines, 'l', true, true)
end
vim.keymap.set({ 'n' }, '<leader>ci', insert_new_cpp_class, { desc = '[C]lass [I]nsert' })
vim.keymap.set({ 'n' }, '<leader>co', vim.cmd.ClassOpen, { desc = '[Class] [O]pen' })
vim.keymap.set({ 'n' }, '<leader>h', vim.cmd.Stdheader, { desc = '[header] for 42 files' })
