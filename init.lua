require 'options'
require 'mappings'
-- those all my utilties and configs inside the configs directory
require 'configs'

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
----

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Use `opts = {}` to force a plugin to be loaded.
require('lazy').setup {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  { import = 'plugins' },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'xiyaowong/transparent.nvim',
    config = function()
      require('transparent').clear_prefix 'Telescope'
    end,
  },
  {
    'Diogo-ss/42-header.nvim',
    cmd = { 'Stdheader' },
    opts = {
      auto_update = false,
      user = 'aljbari',
      mail = 'jbariali002@gmail.com',
    },
    config = function(_, opts)
      require('42header').setup(opts)
    end,
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

-- Function to get active LSP client name
function _G.LspStatus()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  return #clients > 0 and clients[1].name or 'N/A'
end

-- Show the current working lsp
vim.o.statusline = '%<%f %h%w%m%r%=%-14.(%l:%c [%L]%) [%{v:lua.LspStatus()}] %P'
