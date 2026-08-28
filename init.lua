require 'options'
require 'mappings'
require 'configs'

-- Helper function for GitHub repositories used by the new Kickstart
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- CORE PLUGINS
-- ============================================================

-- Detect tabstop and shiftwidth automatically
vim.pack.add { gh 'tpope/vim-sleuth' }

-- lazydev configures Lua LSP for your Neovim config, runtime and plugins
vim.pack.add { gh 'folke/lazydev.nvim' }
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

-- Highlight todo, notes, etc in comments
vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup {
  highlight = {
    before = '',
    keyword = 'fg',
    after = '',
  },
}

-- Transparent background
vim.pack.add { gh 'xiyaowong/transparent.nvim' }
require('transparent').clear_prefix 'Telescope'

-- 42 Header
vim.pack.add { gh 'Diogo-ss/42-header.nvim' }
require('42header').setup {
  auto_update = false,
  user = 'aljbari',
  mail = 'jbariali002@gmail.com',
}

-- ============================================================
-- PLUGIN MODULES
-- ============================================================
-- Explicitly load files from lua/plugins/ replacing Lazy's import system
require 'plugins.autocomplete'
require 'plugins.auto-format'
require 'plugins.color-schem'
require 'plugins.gitsings'
require 'plugins.lspconfig'
require 'plugins.mini'
require 'plugins.multicursor'
require 'plugins.telescope'
require 'plugins.tree-sitter'
require 'plugins.which-key'
