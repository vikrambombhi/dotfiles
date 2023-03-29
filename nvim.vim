call plug#begin()
Plug 'github/copilot.vim', { 'do': ':Copilot setup' }
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
" Install FZF system wide
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" FZF for vim
Plug 'junegunn/fzf.vim'
"
" Language specific libraries
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
"Plug 'python-mode/python-mode', {'branch': 'develop'}
" Basic libraries for all(most) languages
Plug 'sheerun/vim-polyglot'
" Edit surrounding braces/quotes/etc...
Plug 'tpope/vim-surround'
" Auto complete closing braces/quotes/etc...
"Plug 'raimondi/delimitmate'
" Auto Complete
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Linter
Plug 'dense-analysis/ale'
" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pantharshit00/vim-prisma'

" Project specific rules
Plug 'editorconfig/editorconfig-vim'
" Themes
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
call plug#end()

"let g:python_host_prog = '/usr/bin/python'
"let g:python3_host_prog = '/usr/bin/python'

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


" Use deoplete.
"let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
"inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

"ALE
let g:ale_fix_on_save = 1
"" let g:ale_elixir_elixir_ls_release = g:plug_home.'/elixir-ls/rel'
let g:ale_fixers = {
      \   'python': ['autopep8'],
	  \   'javascript': ['prettier'],
	  \   'css': ['prettier'],
      \}

" CoC
" Use Enter to select auto complete
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
" Use tab and shift tab to navigate autocomplete options
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

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
