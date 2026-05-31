require('nvim-tree').setup({})

-- :Tree reveals the current file in the explorer.
vim.api.nvim_create_user_command('Tree', 'NvimTreeFindFile', {})
