require('csvview').setup({
  view = {
    display_mode = 'border',
  },
})

-- csvview doesn't auto-enable; turn on the tabular view whenever a csv/tsv
-- buffer is opened. FileType fires once per buffer load.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'csv' },
  callback = function()
    vim.cmd('CsvViewEnable')
  end,
})
