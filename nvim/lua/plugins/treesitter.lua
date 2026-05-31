-- nvim-treesitter `main` branch: parsers are installed via install() and
-- highlighting/indentation are enabled per buffer with vim.treesitter.start().
-- There is no longer a module system (`highlight`/`indent` tables).

local parsers = {
  'bash',
  'diff',
  'go',
  'json',
  'kotlin',
  'lua',
  'luadoc',
  'luap',
  'markdown',
  'markdown_inline',
  'printf',
  'proto',
  'python',
  'regex',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

-- install() is async and only fetches parsers that are missing.
require('nvim-treesitter').install(parsers)

-- Start treesitter for any buffer whose language has a parser installed.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    -- start() throws if no parser is available; ignore those filetypes.
    if not pcall(vim.treesitter.start, ev.buf) then return end
    -- Treesitter-based indentation (experimental on the main branch).
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
