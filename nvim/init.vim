call plug#begin()
"Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'python-mode/python-mode', {'branch': 'develop'}
Plug 'pangloss/vim-javascript'
" Edit surrounding braces/quotes/etc...
Plug 'tpope/vim-surround'
" Auto complete closing braces/quotes/etc...
Plug 'raimondi/delimitmate'
" Auto Complete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Linter
Plug 'w0rp/ale'
" Themes
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'
call plug#end()


set undofile

"Spacing and tabs
set tabstop=2			"Existing tabs to be shown with 2 spaces
set shiftwidth=2		"Size of indent
set softtabstop=2		"Backspace tab
set expandtab			"Tabs to spaces

" Styling
set cursorline    "highlight current line cusor is on"
set nohlsearch    "Dont continue to highlight search results"

" Quickfix to always open on bottom
au FileType qf wincmd J

"Map <Esc> to exit terminal-mode: >
:tnoremap <Esc> <C-\><C-n>

colorscheme onedark
set laststatus=2


" Use deoplete.
let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

"ALE
let g:ale_fix_on_enter = 1
let g:ale_fix_on_save = 1
let g:ale_fixers = {
      \   'go': ['goimports', 'gofmt'],
      \   'python': ['autopep8'],
      \}

"ripgrep
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
