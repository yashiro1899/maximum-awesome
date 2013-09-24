" don't bother with vi compatibility
set nocompatible

" enable syntax highlighting
syntax enable

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
  source ~/.vimrc.bundles.local
endif

" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set hlsearch
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=4                                             " normal mode indentation commands use 4 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=4                                            " insert mode tab and backspace use 4 spaces
set tabstop=4                                                " actual tabs occupy 8 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion

" Enable basic mouse behavior such as resizing buffers.
" OSX needs https://bitheap.org/mouseterm/
set mouse=a
" if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
" endif

" keyboard shortcuts
let mapleader = ','
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nmap <leader>c :Ack<space>
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>l :NERDTreeFind<CR>
nmap <leader>t :TagbarToggle<CR>
nmap <leader><space> :call whitespace#strip_trailing()<CR>
nmap <leader>g :GitGutterToggle<CR>
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
nmap <C-n> :tabnext<CR>
nmap <C-p> :tabprevious<CR>
imap <C-f> <Right>
imap <C-b> <Left>
imap <C-n> <Down>
imap <C-p> <Up>
imap <C-a> <Home>
imap <C-e> <End>
imap <C-d> <Delete>
vmap <lt> <lt>gv
vmap > >gv
" html tag closer
imap <C-t> <lt>><lt>/><ESC>3hi
imap <C-c> <ESC>vT<yf/pF<i

" folding
map <silent> <leader>f :set foldmethod=indent<CR>zM<CR>
map <silent> <leader>F :set foldmethod=manual<CR>zR<CR>
autocmd FileType html nmap <C-t> zfitj

" plugin settings
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified_removed = '$'

" jslint & csslint
autocmd FileType javascript,css set makeprg=lints\ %
autocmd FileType javascript,css set errorformat=%f(%l):\ %m
autocmd FileType javascript,css imap <F9> <C-o>:make<CR>
autocmd FileType javascript,css nmap <F9> :make<CR>
autocmd FileType javascript vmap <F9> :w !jslint -stdin<CR>
autocmd FileType javascript,json,css,html,tpl vmap <F10> :!all-beautify %<CR>

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'

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
