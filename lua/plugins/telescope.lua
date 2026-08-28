local function gh(repo) return 'https://github.com/' .. repo end

---@type (string|vim.pack.Spec)[]
local telescope_plugins = {
  gh 'nvim-lua/plenary.nvim',
  gh 'nvim-telescope/telescope.nvim',
  gh 'nvim-telescope/telescope-ui-select.nvim',
}

-- Conditionally install fzf-native if `make` is available on your system.
-- The actual `make` build command is handled by the `PackChanged` autocommand in your core init.lua.
if vim.fn.executable 'make' == 1 then
  table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim')
end

-- NOTE: nvim-web-devicons was removed here because the new Kickstart template
-- uses `mini.icons` (via mini.nvim) to handle all icons, which automatically
-- mocks web-devicons for Telescope.

vim.pack.add(telescope_plugins)

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<A-v>'] = 'select_vertical',
      },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'

-- Your custom keymaps
vim.keymap.set('n', '<leader>ff', function()
  local opts = require('telescope.themes').get_ivy()
  builtin.find_files(opts)
end, { desc = '[f]ind [F]iles' })

vim.keymap.set('n', '<leader>fc', builtin.grep_string, { desc = '[f]ind [C]urrent word' })
vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = '[f]ind [W]ord all files' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[f]ind [H]elp' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[f]ind [K]eymaps' })
vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[f]ind [S]elect Telescope' })
vim.keymap.set('n', '<leader>df', builtin.diagnostics, { desc = '[D]iagnostics [f]ind' })
vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[f]ind [R]esume' })
vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[f]ind Recent Files ("." for repeat)' })

vim.keymap.set('n', '<leader><leader>', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.buffers(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[F]ind existing buffers' })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set('n', '<leader>fb', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[F]ind in current [B]uffer' })

-- It's also possible to pass additional configuration options.
-- See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set('n', '<leader>fo', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[f]ind in [O]pen Files' })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })
