-- Collection of various small independent plugins/modules

-- A collection of various small independent plugins/modules
vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

-- KICKSTART OPTIMIZATION: Handle icons globally without nvim-web-devicons
if vim.g.have_nerd_font then
  require('mini.icons').setup()
  -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (like Telescope)
  MiniIcons.mock_nvim_web_devicons()
end

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup {
  -- KICKSTART OPTIMIZATION: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()
