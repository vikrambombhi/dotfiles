call plug#begin()
Plug 'github/copilot.vim', { 'do': ':Copilot setup' }
Plug 'tpope/vim-fugitive' " Git wrapper for vim
Plug 'tpope/vim-rhubarb' " Fugitive-companion to interact with github, enables :Gbrowse
Plug 'airblade/vim-gitgutter' " Show git diff in the sign column

Plug 'scrooloose/nerdtree'

" Language specific libraries
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
" Basic libraries for all(most) languages
Plug 'sheerun/vim-polyglot'
" Edit surrounding braces/quotes/etc...
Plug 'tpope/vim-surround'

" LSP Support using lsp-zero
Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'} " Optional
Plug 'williamboman/mason-lspconfig.nvim'               " Optional
Plug 'neovim/nvim-lspconfig'                           " Required
" Autocompletion
Plug 'hrsh7th/nvim-cmp'     " Required
Plug 'hrsh7th/cmp-nvim-lsp' " Required
Plug 'L3MON4D3/LuaSnip'     " Required

Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}

Plug 'nvim-lua/plenary.nvim' " All the lua functions I don't want to write twice.

" Treesitter for better highlighting 
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'

Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }

" Project specific rules
Plug 'editorconfig/editorconfig-vim'
" Themes
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'rose-pine/neovim', { 'as': 'rose-pine' }

Plug 'lukas-reineke/indent-blankline.nvim' " Vertical lines showing indentation
Plug 'junegunn/goyo.vim' " Distraction free writing
call plug#end()

"let g:python_host_prog = '/usr/bin/python'
"let g:python3_host_prog = '/usr/bin/python'
let mapleader = "\<Space>"

" Use system clipboard
" set clipboard=unnamedplus
set clipboard+=unnamedplus
" dont override clipboard on paste
" pastes and then immeditly yanks what was pasted
xnoremap <expr> p 'pgv"'.v:register.'y`>'
xnoremap <expr> P 'Pgv"'.v:register.'y`>'

set undofile

" Spacing and tabs, tab == 2 spaces
set tabstop=4			"Existing tabs to be shown with 2 spaces
set shiftwidth=4		"Size of indent
set softtabstop=4		"Backspace tab
set expandtab			"Tabs to spaces

" Styling
set cursorline    "highlight current line cusor is on"
set nohlsearch    "Dont continue to highlight search results"
set number       "Show line numbers"

let g:goyo_width = 200

" Quickfix to always open on bottom
au FileType qf wincmd J

"Map <Esc> to exit terminal-mode: >
:tnoremap <Esc> <C-\><C-n>

colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
set termguicolors
set laststatus=2

lua <<EOF
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
lsp.setup()

local function quickfix()
    vim.lsp.buf.code_action({
        filter = function(a) return a.isPreferred end,
        apply = true
    })
end
vim.keymap.set('n', '<leader>qf', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap=true, silent=true })
EOF

lua require('plugins')
