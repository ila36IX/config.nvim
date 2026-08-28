-- Multiple cursor settings

local function gh(repo) return 'https://github.com/' .. repo end

-- Specify the '1.0' branch using the version key
vim.pack.add { { src = gh 'jake-stewart/multicursor.nvim', version = '1.0' } }

local mc = require 'multicursor-nvim'
mc.setup()

local set = vim.keymap.set

-- Add cursor above/below the main cursor.
set({ 'n', 'x' }, '<C-k>', function()
  mc.lineAddCursor(-1)
end)
set({ 'n', 'x' }, '<C-j>', function()
  mc.lineAddCursor(1)
end)

-- Add or skip adding a new cursor by matching word/selection
set({ 'n', 'x' }, '<C-d>', function()
  mc.matchAddCursor(1)
end)
set({ 'n', 'x' }, '<C-y>', function()
  mc.matchSkipCursor(1)
end)

-- Enable and clear cursors using keymap.
mc.addKeymapLayer(function(layerSet)
  layerSet('n', '<leader>ce', function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
end)

-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, 'MultiCursorCursor', { reverse = true })
hl(0, 'MultiCursorVisual', { link = 'Visual' })
hl(0, 'MultiCursorSign', { link = 'SignColumn' })
hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
hl(0, 'MultiCursorDisabledCursor', { reverse = true })
hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
