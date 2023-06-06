call plug#begin()
" Plug 'github/copilot.vim', { 'do': ':Copilot setup' }
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
" Install FZF system wide
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" FZF for vim
Plug 'junegunn/fzf.vim'
"
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

Plug 'pantharshit00/vim-prisma'
" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'mfussenegger/nvim-dap-python'

" Treesitter for better highlighting 
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'

" Project specific rules
Plug 'editorconfig/editorconfig-vim'
" Themes
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
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

" Quickfix to always open on bottom
au FileType qf wincmd J

"Map <Esc> to exit terminal-mode: >
:tnoremap <Esc> <C-\><C-n>

colorscheme challenger_deep
set termguicolors
set laststatus=2

" Dont use copolot for dap-repl
let g:copilot_filetypes = {
            \ 'dap-repl': v:false,
            \ }


lua <<EOF
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['solargraph'] = { 'ruby' },
  }
})

lsp.setup()
EOF

" Configure nvim-dap
lua <<EOF
vim.keymap.set('n', '<leader>dc', '<cmd>lua require"dap".continue()<CR>')
vim.keymap.set('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
vim.keymap.set('n', '<leader>ds', '<cmd>lua require"dap".step_over()<CR>')
vim.keymap.set('n', '<leader>di', '<cmd>lua require"dap".step_into()<CR>')
vim.keymap.set('n', '<leader>do', '<cmd>lua require"dap".step_out()<CR>')
vim.keymap.set('n', '<leader>dq', '<cmd>lua require"dap".disconnect()<CR>')
-- nvim-dap-python
require('dap-python').setup('python')
-- nvim-dap-ui
local dapui_config = {
    layouts = {
        {
                elements = {
                    {
                            id = "scopes",
                            size = 0.25,
                    },
                    { id = "breakpoints", size = 0.25 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 0.25 },
                },
                size = 40,
                position = "left",
                },
        {
                elements = {
                    "repl",
                },
                size = 10,
                position = "bottom",
        },
        },
}
require('dapui').setup(dapui_config)
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
EOF

"""KEY MAPPINGS"""
"ripgrep
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
let g:rg_command = 'rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!{node_modules/*,.git/*,vendor/*}" --color "always" '
command! -bang -nargs=* Find
  \ call fzf#vim#grep(
  \   g:rg_command .shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%'),
  \   <bang>0)
set grepprg=rg\ --vimgrep
nnoremap <C-f> :Find<space><C-F>i
vnoremap <C-f> y:Find<space><C-R>"<CR>
