call plug#begin()
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
Plug 'tpope/vim-surround'
Plug 'bling/vim-airline'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()

"Backup and swap files
set undofile
set backupdir=~/.vim/.backup//          "Dir for vim to save backup files
set directory=~/.vim/.swap//            "Dir for vim to save swap files
set undodir=~/.vim/.undo//              "Undo dir for vim


"Colorscheme
if (has("termguicolors"))
  set termguicolors
  "Set Vim-specific sequences for RGB colors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
colorscheme onedark

"Spacing and tabs
set backspace=indent,eol,start 	"Add this to your vimrc to make the backspace work like in most other programs
set tabstop=4			"Existing tabs to be shown with 2 spaces
set shiftwidth=4		"Size of indent
set softtabstop=4		"Backspace tab
set expandtab			"Tabs to spaces


set laststatus=2
