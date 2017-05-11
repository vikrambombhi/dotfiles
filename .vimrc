call plug#begin()
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/syntastic'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
Plug 'tpope/vim-surround'
Plug 'bling/vim-airline'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
call plug#end()

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
set tabstop=2			"Existing tabs to be shown with 2 spaces
set shiftwidth=2		"Size of indent
set softtabstop=2		"Backspace tab
set expandtab			"Tabs to spaces


set laststatus=2
