-- Sticky scope context at the top of the window.
require('treesitter-context').setup({
  -- Disable in markdown, where the context lines are noise rather than scope.
  on_attach = function(buf)
    return vim.bo[buf].filetype ~= 'markdown'
  end,
})
