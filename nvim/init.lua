-- Leader keys must be set before any plugin loads so mappings register correctly.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require('config.options')
require('config.pack')
