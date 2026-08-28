-- Autocompletion

-- [[ Snippet Engine ]]
vim.pack.add { { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }

local luasnip = require 'luasnip'
luasnip.setup {}

-- Your snippet jump keymaps (extracted from your old cmp mapping)
vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
end, { desc = 'LuaSnip expand or jump forward' })

vim.keymap.set({ 'i', 's' }, '<C-h>', function()
  if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
end, { desc = 'LuaSnip jump backward' })

-- [[ Autocomplete Engine ]]
vim.pack.add { { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' } }

local blink_opts = {
  keymap = {
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    ['<Tab>'] = { 'select_and_accept', 'fallback' },
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
    },
  },

  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}

-- Strip the 'kind_icon' column if Nerd Fonts are disabled in options.lua
if not vim.g.have_nerd_font then blink_opts.completion.menu = {
  draw = {
    columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } },
  },
} end

require('blink.cmp').setup(blink_opts)
