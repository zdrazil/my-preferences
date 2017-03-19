" This must be first, because it changes other options as a side effect.
set nocompatible

" ================ General Config ====================

set backspace=indent,eol,start  "Allow backspace in insert mode

if &history < 1000
  set history=1000 "Store lots of :cmdline history
endif

if &tabpagemax < 50
    set tabpagemax=50 "Allow for up to 50 opened tabs on Vim start
endif

set autoread                    "Reload files changed outside vim

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif
set encoding=utf-8
set complete-=i
set hidden
set nrformats-=octal            "What base vim considers for increment

"turn on syntax highlighting
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" characters used for list command
if &listchars ==# 'eol:$'
    set listchars=
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

" Search upwards for tags file instead only locally
if has('path_extra')
    setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

set background=dark
" colorscheme monokai
let macvim_skip_colorscheme=1

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab

"Spaces & Tabs
set tabstop=4 " number of visual spaces per TAB
set shiftwidth=4
set softtabstop=4 " number of spaces in tab when editing
set expandtab     " tabs are spaces

filetype on
if has ('autocmd')
  filetype plugin on
  filetype indent on
endif

"Wrapping
set wrap
set linebreak  " don't split words in the middle
set nolist     " list disables linebreak
set textwidth=0
set wrapmargin=0
set formatoptions-=t
set colorcolumn=80

" Clipboard
set clipboard=unnamed,unnamedplus

" Mouse
set mouse=a

" Undo
set undodir=~/.vim/undodir/
set undofile

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**

" ================ Scrolling ========================

if !&scrolloff
  set scrolloff=1         "Start scrolling when we're 3 lines away from
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set sidescroll=1

" ================ Search ===========================

set incsearch       " search as characters are entered
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " If there are uppercase letters, become case-sensitive.
set showmatch       " highlight matching [{()}]

" ================ UI Config =========================
set number              " show line numbers
set showcmd             " show command in bottom bar
set showmode            " show current mode down the bottom
set lazyredraw          " redraw only when we need to.
set title               " e.g. | page.html (~) - VIM | as a windows title
set ruler               " Enable limited line numbering
set visualbell          "Instead of hearing beep, show a brief window flash.

" ================ Backups ===========================
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" ================ Aliases ===========================

" ================ Packages ===========================
call plug#begin('~/.vim/plugged')

" Easier to set up than Command T
" Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
Plug 'https://github.com/ctrlpvim/ctrlp.vim'

" Youcomplemete is better than Neocomplete (everything built in), deoplete (only for neovim)
" vimcompletesme (lightweight, needs tags)
" YCM - MUST COMPILE
" install with PATH=/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/bin:$PATH
" ./install.py --clang-completer --tern-completer 
" A code-completion engine for Vim
" Plug 'https://github.com/Valloric/YouCompleteMe'
Plug 'https://github.com/ajh17/VimCompletesMe'

" Syntax checking plugin
Plug 'https://github.com/vim-syntastic/syntastic'

" Comment stuff out with gcc
Plug 'https://github.com/tpope/vim-commentary'

" Surround text in parenthesis etc.
Plug 'https://github.com/tpope/vim-surround'

" Better Python indentation 
Plug 'https://github.com/vim-scripts/indentpython.vim'

" automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on
" the current file
" better than DetectIndent (fully automatic)
Plug 'https://github.com/tpope/vim-sleuth'

" A collection of language packs for Vim.
Plug 'https://github.com/sheerun/vim-polyglot'

" shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'https://github.com/airblade/vim-gitgutter'

" highlights which characters to target for f, F and family
Plug 'https://github.com/unblevable/quick-scope'

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

Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'

call plug#end()

colorscheme monokai

" Ack.vim
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" Lightline
set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ }

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode': 'passive' }

" tmux
let g:slime_target = "tmux"
let g:slime_python_ipython = 1

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

:nmap <silent> <leader>d <Plug>DashSearch

" ================ File Formats =====================

"python with virtualenv support
" py << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
"   project_base_dir = os.environ['VIRTUAL_ENV']
"   activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"   execfile(activate_this, dict(__file__=activate_this))
" EOF

" ================ Sources ===========================

" ================ Keybindings =======================

"Dash Plugin mapping
:nmap <silent> <leader>d <Plug>DashSearch

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" http://dougblack.io/words/a-good-vimrc.html
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" https://github.com/skwp/dotfiles/blob/master/vimrc
