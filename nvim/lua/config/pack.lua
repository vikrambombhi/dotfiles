-- Plugin management via Neovim 0.12's built-in `vim.pack`.
--
-- `vim.pack.add` clones missing plugins into the pack directory, adds them to
-- the runtimepath and loads them immediately, so each plugin's code is usable
-- right after this call. Versions are locked in $XDG_CONFIG_HOME/nvim/nvim-pack-lock.json.

-- nvim-treesitter (main branch) ships no compiled parsers; they're built by the
-- plugin itself. Rebuild them whenever the plugin is installed or updated.
-- Registered before add() so it also fires on the very first install.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name ~= 'nvim-treesitter' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    pcall(function() require('nvim-treesitter').update() end)
  end,
})

vim.pack.add({
  -- Colorscheme
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },

  -- Treesitter (main branch — new install()/vim.treesitter.start() API)
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },

  -- File explorer + icons
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },

  -- Fuzzy finder
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },

  -- LSP: native vim.lsp.config/enable + nvim-lspconfig defaults, servers via mason
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },

  -- Completion (pinned to a 1.x release tag so the prebuilt fuzzy binary is used)
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('1') },

  -- Git
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/tpope/vim-rhubarb' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },

  -- Editing UI
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },

  -- CSV
  { src = 'https://github.com/hat0uma/csvview.nvim' },
})

-- Configure plugins. Order matters: colors first, then treesitter (consumed by
-- render-markdown), completion before LSP (so capabilities are available).
require('plugins.catppuccin')
require('plugins.treesitter')
require('plugins.treesitter-context')
require('plugins.nvim-tree')
require('plugins.telescope')
require('plugins.blink')
require('plugins.lsp')
require('plugins.gitsigns')
require('plugins.indent-blankline')
require('plugins.render-markdown')
require('plugins.csvview')

-- vim-fugitive / vim-rhubarb need no setup; loading them via vim.pack is enough.
