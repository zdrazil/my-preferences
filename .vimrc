" This must be first, because it changes other options as a side effect.
set nocompatible

" ================ General Config ====================
set hidden
set encoding=utf-8

let macvim_skip_colorscheme=1
colorscheme default
" set background=light

" ================ Indentation ======================
set cursorline

"Spaces & Tabs
set shiftwidth=4
set softtabstop=4 " number of spaces in tab when editing
set expandtab     " tabs are spaces

"Wrapping
set linebreak  " don't split words in the middle
set textwidth=0
set wrapmargin=0
set formatoptions-=t
set colorcolumn=80

" Mouse
set mouse=a

set clipboard^=unnamedplus,unnamed

" Undo
set undodir=~/.vim/undodir/
set undofile

" ================ Completion =======================
set wildignorecase
set wildmode=list:longest,full
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**

" ================ Search ===========================
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set showmatch       " highlight matching [{()}]

" ================ UI Config =========================
set showcmd
set showmode
set number
set title               " e.g. | page.html (~) - VIM | as a windows title
set ruler               " Enable limited line numbering

" ================ Backups ===========================
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" ================ Aliases ===========================

" ================ Packages ===========================
call plug#begin('~/.vim/plugged')

" Vim sensible - sane vim defaults
Plug 'tpope/vim-sensible'

" Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
Plug 'https://github.com/ctrlpvim/ctrlp.vim'

" Youcomplemete is better than Neocomplete (everything built in), deoplete (only for neovim)
" vimcompletesme (lightweight, needs tags)
" YCM - MUST COMPILE
" A code-completion engine for Vim
" Plug 'https://github.com/Valloric/YouCompleteMe'
Plug 'ajh17/VimCompletesMe'

" Syntax checking plugin
" Plug 'https://github.com/vim-syntastic/syntastic'

" Comment stuff out with gcc
Plug 'https://github.com/tpope/vim-commentary'

" Surround text in parenthesis etc.
Plug 'https://github.com/tpope/vim-surround'

" Better Python indentation 
" Plug 'https://github.com/vim-scripts/indentpython.vim'

" automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on
" the current file
" better than DetectIndent (fully automatic)
Plug 'https://github.com/tpope/vim-sleuth'
    
" A collection of language packs for Vim.
Plug 'https://github.com/sheerun/vim-polyglot'

" shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'https://github.com/airblade/vim-gitgutter'

" highlights which characters to target for f, F and family
" Plug 'https://github.com/unblevable/quick-scope'

" makes scrolling nice and smooth
Plug 'yonchu/accelerated-smooth-scroll'

" Search for terms using the Dash.app
Plug 'rizzatti/dash.vim'

" Status/tabline for vim
Plug 'itchyny/lightline.vim'

" Use ack instead of grep
Plug 'mileszs/ack.vim'

" Auto generate ctags
Plug 'ludovicchabant/vim-gutentags'

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" Python plugins
Plug 'heavenshell/vim-pydocstring'

" Plug 'altercation/vim-colors-solarized'
" Plug 'chriskempson/base16-vim'

call plug#end()


let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ }

runtime plugin/sensible.vim

" Ack.vim
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" Syntastic
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_wq = 0

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" ================ File Formats =====================

" ================ Sources ===========================

" ================ Keybindings =======================

"Dash Plugin mapping
:nmap <silent> <leader>d <Plug>DashSearch

" http://dougblack.io/words/a-good-vimrc.html
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" https://github.com/skwp/dotfiles/blob/master/vimrc
