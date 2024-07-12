local lsp_zero = require('lsp-zero').preset({})

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here
  -- with the ones you want to install
  ensure_installed = {'tsserver', 'sorbet'},
  handlers = {
    lsp_zero.default_setup,
  }
})

-- rubocop is installed manually with asdf instead of by using mason
-- its needed because otherwise the rubocop plugins wont work (e.g. rubocop-graphql)
require('lspconfig').rubocop.setup({})

lsp_zero.setup()

-- leader + qf to lsp quick fix (code action)
local function quickfix()
    vim.lsp.buf.code_action({
        filter = function(a) return a.isPreferred end,
        apply = true
    })
end
vim.keymap.set('n', '<leader>qf', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap=true, silent=true })
