-- Multiple cursor settings
return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
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

    -- Skip next I couldn't think of a good keybind, maybe later...
    -- set({ 'n', 'x' }, '<C-i>', function()
    --   mc.lineSkipCursor(-1)
    -- end)
    -- set({ 'n', 'x' }, '<C-u>', function()
    --   mc.lineSkipCursor(1)
    -- end)

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
  end,
}
