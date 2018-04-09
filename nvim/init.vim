call plug#begin()
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer --gocode-completer' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'raimondi/delimitmate'
Plug 'arcticicestudio/nord-vim'
call plug#end()

"Backup and swap files
set undofile
set backupdir=~/.config/nvim/.backup//          "Dir for vim to save backup files
set directory=~/.config/nvim/.swap//            "Dir for vim to save swap files
set undodir=~/.config/nvim/.undo//              "Undo dir for vim

"Spacing and tabs
set tabstop=2			"Existing tabs to be shown with 2 spaces
set shiftwidth=2		"Size of indent
set softtabstop=2		"Backspace tab
set expandtab			"Tabs to spaces

" Use deoplete.
let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

"To map <Esc> to exit terminal-mode: >
:tnoremap <Esc> <C-\><C-n>

colorscheme nord
set laststatus=2
