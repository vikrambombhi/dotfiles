-- Use the system clipboard for all yank/delete/put operations.
vim.opt.clipboard = 'unnamedplus'

-- Two-space, expandtab indentation.
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Treesitter-based folding (parsers attach per buffer in plugins/treesitter.lua).
-- Start with everything unfolded.
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
