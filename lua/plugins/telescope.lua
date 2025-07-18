-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`

    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        mappings = {
          i = {
            ['<A-v>'] = 'select_vertical',
          },
        },
      },
      -- pickers = {}
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>ff', function()
      local opts = require('telescope.themes').get_ivy()
      builtin.find_files(opts)
    end, { desc = '[f]ind [F]iles' })
    vim.keymap.set('n', '<leader>fc', builtin.grep_string, { desc = '[f]ind [C]urrent word' })
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = '[f]ind by [W]ord in all files' })
    vim.keymap.set('n', '<leader>fg', function()
      builtin.grep_string { search = vim.fn.input 'Grep > ' }
    end, { desc = '[f]ind [G]rep string' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[f]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[f]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[f]ind [S]elect Telescope' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[f]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[f]ind [R]esume' })
    vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[f]ind Recent Files ("." for repeat)' })
    -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

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

    -- Cd into directory
    vim.keymap.set('n', '<leader>cd', function()
      builtin.find_directories {
        prompt_title = 'Select Directory to CD Into',
        -- This function is called when a directory is selected from the picker.
        on_confirm = function(selection)
          -- 'selection' is a table containing information about the selected item.
          -- For find_directories, selection[1].path will be the full path.
          local selected_path = selection[1].path

          -- -- Execute the Vim 'cd' command with the selected path.
          -- -- 'vim.cmd' allows you to run Vim commands from Lua.
          -- -- We use 'silent!' to suppress messages if the directory doesn't exist (though Telescope should prevent this).
          -- -- We also use 'lcd' (local change directory) to change the directory only for the current window,
          -- -- which is often preferred in Neovim/Vim for better session management.
          -- -- If you prefer a global 'cd', change 'lcd' to 'cd'.
          -- vim.cmd('silent! lcd ' .. vim.fn.fnameescape(selected_path))
          --
          -- -- Optionally, print a message to confirm the directory change.
          print('Changed directory to: ' .. selected_path)
        end,
        -- Other options for find_directories can be added here, e.g.:
        -- cwd = vim.fn.getcwd(), -- Start search from current working directory
        -- hidden = true, -- Include hidden directories
      }
    end, { desc = '[C]hange [D]irectory' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
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
  end,
}
