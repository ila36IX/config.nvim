  -- Main LSP Configuration

local function gh(repo) return 'https://github.com/' .. repo end

-- Useful status updates for LSP
vim.pack.add { gh 'j-hui/fidget.nvim' }
require('fidget').setup {}

-- LSP Attach Autocommand
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local builtin = require('telescope.builtin')

    -- User Keymaps
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>da', vim.lsp.buf.code_action, '[D]iagnostics [A]ction', { 'n', 'x' })
    map('grr', builtin.lsp_references, '[G]oto [R]eferences')
    map('gri', builtin.lsp_implementations, '[G]oto [I]mplementation')
    map('grd', builtin.lsp_definitions, '[G]oto [D]efinition')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gO', builtin.lsp_document_symbols, 'Open Document Symbols')
    map('gW', builtin.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
    map('grt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- KICKSTART OPTIMIZATION: Highlight references on CursorHold
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- KICKSTART OPTIMIZATION: Toggle Inlay Hints
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- User Diagnostic Config
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E ',
      [vim.diagnostic.severity.WARN] = 'W ',
      [vim.diagnostic.severity.INFO] = 'I ',
      [vim.diagnostic.severity.HINT] = 'H ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

-- Mason and LSP Packages
vim.pack.add {
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}

-- Setup Mason
require('mason').setup {}
require('mason-lspconfig').setup {
  automatic_enable = false,
}

-- Broadcast capabilities to servers using blink.cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
if pcall(require, 'blink.cmp') then
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
end

local servers = {
  clangd = {},
  -- ts_ls = {},
  -- svelte = {},
}

-- Ensure tools are installed
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'stylua', -- Used to format Lua code
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- Initialize LSP Servers
for name, server in pairs(servers) do
  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end
