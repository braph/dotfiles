" === Plugin Manager
"> include vundle.vim
" ==================

syntax on
set hidden

" === Correct typos
ca WQ wq
ca wQ wq
ca Wq wq

ca QW wq
ca Qw wq
ca qW wq
ca qw wq

ca W w
ca Q q

ca q1 q!
ca Q1 q!
" =================

" Store viminfo in a sane place
set viminfo+=nBASE_DIR/viminfo

set fdm=marker
set foldmarker={{{,}}}

set smartcase
set ignorecase

set norelativenumber
set number
set showmatch

set incsearch
set hlsearch

set autoindent
set cindent

set tabstop=2
set shiftwidth=2
set expandtab

set mouse=n

if has("autocmd")
  " When editing a file, always jump to the last known cursor position. 
  " Don't do it when the position is invalid or when inside an event handler 
  " (happens when dropping a file on gvim). 
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif


  " save view for file
  au BufWrite           * silent! mkview
  au BufNewFile,BufRead * silent! loadview


  au BufNewFile   *.sh          0r BASE_DIR/skeltons/bash.skel
  au BufNewFile   *.php         0r BASE_DIR/skeltons/php.skel
  au BufNewFile   *.pl          0r BASE_DIR/skeltons/perl.skel
  au BufNewFile   main.cpp      0r BASE_DIR/skeltons/main.cpp.skel
  au BufNewFile   main.c        0r BASE_DIR/skeltons/main.c.skel
  au BufReadPost  pacman.log    set ft=pacmanlog
endif " has("autocmd")

" completion
set wildignore=*.a,*.o,*.so,*.pyc,*.jpg,
            \*.jpeg,*.png,*.gif,*.pdf,*.git,
            \*.swp,*.swo                    " tab completion ignores
set wildmenu                                " better auto complete
set wildmode=longest,list                   " bash-like auto complete

" don't include other files while completing
set complete-=i

" === bindings
 " Highlight last inserted text
 nnoremap gV '[V']

 " Disable annoying ex mode (Q)
 map Q <nop>

 " Buffers, preferred over tabs now with bufferline.
 nnoremap gn :bnext<CR>
 nnoremap gN :bprevious<CR>
 nnoremap gD :bdelete<CR>
 nnoremap gf <C-^>

 " Treat wrapped lines as normal lines
 nnoremap j gj
 nnoremap k gk

 " SelectBuf Plugin
 nnoremap <Leader>sb :SelectBuf<ENTER>
 nnoremap g"         :SelectBuf<ENTER>
" ============

" Disable double ESC
set timeoutlen=1000 ttimeoutlen=0

" Disable statusline
set laststatus=0

"> if SLOW_SYSTEM == 1
set noruler
set nocursorline
set lazyredraw
set scrolljump=10
"> else
set ruler
set cursorline
"> endif

"> Draw a vertical line at column 80
set colorcolumn=80
highlight ColorColumn ctermbg=235 

"> change highlight color
hi Search cterm=bold ctermfg=blue ctermbg=black
