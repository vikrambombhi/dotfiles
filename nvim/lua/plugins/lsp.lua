-- Native LSP (Neovim 0.11+): vim.lsp.config() customizes servers, vim.lsp.enable()
-- turns them on. nvim-lspconfig provides the per-server defaults (lsp/<name>.lua),
-- mason installs the server binaries, and mason-lspconfig bridges the two and
-- auto-enables every installed server.

-- Diagnostics appearance.
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.HINT] = '⚑',
      [vim.diagnostic.severity.INFO] = '»',
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = true, header = '', prefix = '' },
})

-- Advertise blink.cmp's completion capabilities to every server.
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Per-server overrides (merged onto nvim-lspconfig's defaults).
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemas = {
        -- The token in these URLs expires; refresh from:
        --   https://github.com/dialoguemd/charts/raw/master/app/schema.json
        --   https://github.com/dialoguemd/charts/raw/master/job/schema.json
        ['/Users/vikram/dev/charts/app/schema.json'] = { 'app.yaml', 'app.yml' },
        ['/Users/vikram/dev/charts/job/schema.json'] = { 'job.yaml', 'job.yml' },
      },
    },
  },
})

-- Install servers and let mason-lspconfig auto-enable them.
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'ty',
    'protols',
  },
})

-- Buffer-local keymaps once a server attaches. Neovim 0.11 already maps many
-- LSP actions by default (grn rename, gra code action, grr references,
-- gri implementation, K hover); these fill in the rest.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
