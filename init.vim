" Vim script for Evim key bindings
" Maintainer:	The Vim Project <https://github.com/vim/vim>
" Last Change:	2023 Aug 10
" Former Maintainer:	Bram Moolenaar <Bram@vim.org>

" Don't use Vi-compatible mode.
set nocompatible

" Use the mswin.vim script for most mappings
source <sfile>:p:h/mswin.vim

" Allow for using CTRL-Q in Insert mode to quit Vim.
inoremap <C-Q> <C-O>:confirm qall<CR>

" Vim is in Insert mode by default
set insertmode

" Make a buffer hidden when editing another one
set hidden

" Make cursor keys ignore wrapping
inoremap <silent> <Down> <C-R>=pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"<CR>
inoremap <silent> <Up> <C-R>=pumvisible() ? "\<lt>Up>" : "\<lt>C-O>gk"<CR>

" CTRL-F does Find dialog instead of page forward
noremap <silent> <C-F> :promptfind<CR>
vnoremap <silent> <C-F> y:promptfind <C-R>"<CR>
onoremap <silent> <C-F> <C-C>:promptfind<CR>
inoremap <silent> <C-F> <C-O>:promptfind<CR>
cnoremap <silent> <C-F> <C-C>:promptfind<CR>


set backspace=2		" allow backspacing over everything in insert mode
set autoindent		" always set autoindenting on
if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set incsearch		" do incremental searching
set mouse=a		" always use the mouse

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Highlight the last used search pattern on the next search command.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  nohlsearch
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" For all text files set 'textwidth' to 78 characters.
au FileType text setlocal tw=78

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" vim: set sw=2 

" Enable search highlighting
set hlsearch
set incsearch

set nobackup
set noswapfile
set re=0
set ignorecase
set smartcase

set clipboard^=unnamed,unnamedplus

if ! &insertmode
	set number
	set relativenumber
endif


" Highlight the current search match differently from other matches
" IncSearch: highlight during incremental search (the match you're typing)
" Search: highlight all matches
highlight IncSearch ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
highlight Search ctermbg=DarkGray ctermfg=White guibg=DarkGray guifg=White

" Ctrl + f to begin searching
inoremap <c-f> <c-o>/

" Ctl + f (x2) to stop highlighting the search results
inoremap <c-f>f <c-o>:nohlsearch<cr>
inoremap <c-f><c-f> <c-o>:nohlsearch<cr>

" F3 go to the previous match
inoremap <c-p> <c-o>:normal Nzz<cr>

" F4 go to the next match
inoremap <c-n> <c-o>:normal nzz<cr>

" Ctrl + h begin a search and replace
inoremap <c-h> <c-o>:%s///gc<Left><Left><Left><Left>

" Ctrl + x to delete current line
nnoremap <c-x> dd
inoremap <c-x> <c-o>dd

" Ctrl + d to duplicate current line
nnoremap <c-d> yyp
inoremap <c-d> <C-o>:normal yyp<CR>
