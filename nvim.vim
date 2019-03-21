function! InstallElixirLangServer(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !mkdir rel && yes | mix deps.get && yes | mix compile && mix elixir_ls.release -o rel
  endif
endfunction

call plug#begin()
"Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
" Install FZF system wide
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" FZF for vim
Plug 'junegunn/fzf.vim'
" Language specific libraries
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'python-mode/python-mode', {'branch': 'develop'}
Plug 'pangloss/vim-javascript'
Plug 'JakeBecker/elixir-ls', { 'do': function('InstallElixirLangServer')}
" Basic libraries for all(most) languages
Plug 'sheerun/vim-polyglot'
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

" Spacing and tabs, tab == 2 spaces
set tabstop=2			"Existing tabs to be shown with 2 spaces
set shiftwidth=2		"Size of indent
set softtabstop=2		"Backspace tab
set expandtab			"Tabs to spaces

" Use 4 spaces as tab for Java
autocmd FileType java setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab!

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
let g:ale_elixir_elixir_ls_release = g:plug_home.'/elixir-ls/rel'
let g:ale_fixers = {
      \   'go': ['goimports', 'gofmt'],
      \   'python': ['autopep8'],
      \   'elixir': ['mix_format'],
      \}

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
let g:rg_command = 'ripgrep.rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!{.git/*,vendor/*}" --color "always" '
command! -bang -nargs=* Find
  \ call fzf#vim#grep(
  \   g:rg_command .shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%'),
  \   <bang>0)
set grepprg=rg\ --vimgrep
nnoremap <C-f> :Find<space><C-F>i
vnoremap <C-f> y:Find<space><C-R>"<CR>
