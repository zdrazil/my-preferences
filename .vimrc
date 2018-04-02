" ================ General Config ====================
set hidden
set encoding=utf-8

" ================ Indentation ======================

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

" === UI ===
" = Windows, buffer, tab management =

" Continuously updated session files
Plug 'tpope/vim-obsession'

" = Color schemes =
" Plug 'robertmeta/nofrils'
Plug 'altercation/vim-colors-solarized'
" Plug 'chriskempson/base16-vim'
" Plug 'vim-scripts/CycleColor'

" === File and project management ===
" == Searching ==
" Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Use ack instead of grep
Plug 'mileszs/ack.vim'

" === Documentation ===

" === Editing ===

" A code-completion engine for Vim
Plug 'ajh17/VimCompletesMe'

" Automatically adjusts 'shiftwidth' and 'expandtab' heuristically based
" on the current file
Plug 'tpope/vim-sleuth'
" Comment stuff out with gcc
Plug 'tpope/vim-commentary'
" Surround text in parenthesis etc.
Plug 'tpope/vim-surround'
" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" EditorConfig plugin
Plug 'editorconfig/editorconfig-vim'

call plug#end()

runtime plugin/sensible.vim

" Ack.vim
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
    " let g:ackprg = 'rg --vimgrep --no-heading'
endif

" ================ File Formats =====================

" ================ Sources ===========================

" ================ Keybindings =======================
let g:mapleader = "\<Space>"
inoremap <C-Space> <Space> 

" FZF
nnoremap <leader>o :FZF<cr>
nnoremap <leader>p :Commands<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>/ :Lines<cr>

" ================ Commands =========================

" http://dougblack.io/words/a-good-vimrc.html
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" https://github.com/skwp/dotfiles/blob/master/vimrc
