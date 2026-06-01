-- Native LSP (Neovim 0.11+).
--
-- How the pieces fit together:
--   * nvim-lspconfig ships the per-server defaults as `lsp/<name>.lua` files.
--     `vim.lsp.enable(name)` finds that config and starts the server for
--     matching filetypes. `vim.lsp.config(name, {...})` merges in overrides.
--   * mason.nvim installs the server *binaries* into its own directory and
--     prepends it to Neovim's PATH, so `vim.lsp.enable` can launch them.
--
-- We dropped mason-lspconfig (the auto-install + auto-enable bridge) and do
-- both steps by hand: install servers once with `:MasonInstall <names>` (see
-- SERVERS below), and enable them explicitly here. Manage servers via `:Mason`.

-- Language servers to enable. Install the binaries once with:
--   :MasonInstall ty protols
local SERVERS = {
  'ty',      -- Python (Astral)
  'protols', -- Protobuf
}

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

-- mason.setup() must run before vim.lsp.enable so the server binaries are on
-- Neovim's PATH when the servers start.
require('mason').setup()
vim.lsp.enable(SERVERS)

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
