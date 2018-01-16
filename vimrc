" don't bother with vi compatibility
set nocompatible

" enable syntax highlighting
syntax enable

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off
set rtp+=~/.vim/bundle/vundle.vim/
call vundle#begin()

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
  source ~/.vimrc.bundles.local
endif

call vundle#end()

" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

set autoindent
set autoread                                  " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                               " Fix broken backspace in some setups
set backupcopy=yes                            " see :help crontab
set clipboard=unnamed                         " yank and paste with the system clipboard
set complete+=k
set directory-=.                              " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                 " expand tabs to spaces
set hlsearch
set ignorecase                                " case-insensitive search
set incsearch                                 " search as you type
set list                                      " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number                                    " show line numbers
set ruler                                     " show where you are
set scrolloff=3                               " show context above/below cursorline
set shiftwidth=2                              " normal mode indentation commands use 2 spaces
set showcmd
set smartcase                                 " case-sensitive search if any caps
set softtabstop=2                             " insert mode tab and backspace use 2 spaces
set splitright
set tabstop=2                                 " actual tabs occupy 2 characters
set wildignore=log/**,target/**,tmp/**,*.rbc
set wildmenu                                  " show a navigable menu for tab completion

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif

" keyboard shortcuts
let mapleader=','
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>e :FencAutoDetect<CR>
nnoremap <leader>l :NERDTreeFind<CR>
nnoremap <leader>n :noh<CR>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader><space> :retab<CR>:call whitespace#strip_trailing()<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Delete>
vnoremap <lt> <lt>gv
vnoremap > >gv

" folding
noremap <leader>2 :set shiftwidth=2<CR>:set softtabstop=2<CR>:set tabstop=2<CR>
noremap <leader>4 :set shiftwidth=4<CR>:set softtabstop=4<CR>:set tabstop=4<CR>
noremap <silent> <leader>f :set foldmethod=indent<CR>zM<CR>
noremap <silent> <leader>F :set foldmethod=manual<CR>zR<CR>

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" plugin settings
let g:NERDSpaceDelims=1

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" reset colors
autocmd VimLeave * !echo -ne '\033[0m'

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal! g'\"" |
\ endif

" Go crazy!
if filereadable(expand("~/.vimrc.local"))
  " In your .vimrc.local, you might like:
  "
  " set autowrite
  " set nocursorline
  " set nowritebackup
  " set whichwrap+=<,>,h,l,[,] " Wrap arrow keys between lines
  "
  " autocmd! bufwritepost .vimrc source ~/.vimrc
  " noremap! jj <ESC>
  source ~/.vimrc.local
endif
