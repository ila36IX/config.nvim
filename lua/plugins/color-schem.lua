-- You can easily change to a different colorscheme.
-- Change the name of the colorscheme plugin below, and then
-- change the command in the config to whatever the name of that colorscheme is.
--
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--
-- 'folke/tokyonight.nvim',
-- 'yorumicolors/yorumi.nvim',
return {
  -- 'EdenEast/nightfox.nvim',
  -- 'olimorris/onedarkpro.nvim',
  -- 'oxfist/night-owl.nvim',
  -- 'luisiacc/the-matrix.nvim',
  'folke/tokyonight.nvim',
  -- 'zenbones-theme/zenbones.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    -- vim.cmd.colorscheme 'carbonfox'
    -- good defaul one
    vim.cmd.colorscheme 'tokyonight'
    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
  opts = {
    style = 'storm',
    light_style = 'day',
    transparent = true,
    styles = {
      keywords = { italic = false },
    },
  },
}
