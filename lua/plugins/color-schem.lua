vim.pack.add { 'https://github.com/oxfist/night-owl.nvim' }

require('night-owl').setup {
  bold = true,
  italics = false,
  underline = true,
  transparent_background = true,
}

vim.cmd.colorscheme 'night-owl'
vim.cmd.hi 'Comment gui=bold'
