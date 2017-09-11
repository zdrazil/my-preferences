" This must be first, because it changes other options as a side effect.
set nocompatible

" ================ General Config ====================
set hidden
set encoding=utf-8

let macvim_skip_colorscheme=1
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

" === UI ===
" = Windows, buffer, tab management =
" Takes over the tabline and renders the buffer list in it instead of a tab list
Plug 'ap/vim-buftabline'

" = Color schemes =
Plug 'robertmeta/nofrils'
" Plug 'altercation/vim-colors-solarized'
" Plug 'chriskempson/base16-vim'
" Plug 'vim-scripts/CycleColor'

" === File and project management ===
" == Searching ==
" Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
" Plug 'https://github.com/ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nnoremap <c-p> :FZF<cr>

" Use ack instead of grep
Plug 'mileszs/ack.vim'

" === Documentation ===
" Auto generate ctags
Plug 'ludovicchabant/vim-gutentags'

" Look Up Documentation 
Plug 'rizzatti/dash.vim'
nmap <silent> <leader>d <Plug>DashSearch
" Plug 'rhysd/devdocs.vim'
" Plug 'keith/investigate.vim'

" === Editing ===
" Syntax checking plugin
Plug 'https://github.com/vim-syntastic/syntastic'

" A code-completion engine for Vim
Plug 'https://github.com/Valloric/YouCompleteMe'
" Plug 'ajh17/VimCompletesMe'

" Automatically adjusts 'shiftwidth' and 'expandtab' heuristically based
" on the current file
" better than DetectIndent (fully automatic)
Plug 'https://github.com/tpope/vim-sleuth'
" Comment stuff out with gcc
Plug 'https://github.com/tpope/vim-commentary'
" Surround text in parenthesis etc.
Plug 'https://github.com/tpope/vim-surround'
" Text filtering and alignment
Plug 'godlygeek/tabular'
" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" EditorConfig plugin
Plug 'editorconfig/editorconfig-vim'

" Shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'https://github.com/airblade/vim-gitgutter'
" Quick way to create lists in Vim 
" Plug 'KabbAmine/lazyList.vim'

" === Languages ====
" A collection of language packs for Vim.
Plug 'https://github.com/sheerun/vim-polyglot'

" = HTML =
" Provides support for expanding abbreviations similar to emmet
Plug 'mattn/emmet-vim'

" = Markdown =
" Vim plugin for automated bullet lists.
Plug 'dkarter/bullets.vim'

" = JavaScript =
" Tern-based JavaScript editing support
" Plug 'ternjs/tern_for_vim'
" Improved Javascript indentation and syntax support in Vim
Plug 'pangloss/vim-javascript'
" React JSX syntax highlighting and indenting for vim.
Plug 'mxw/vim-jsx'
" Syntax for JavaScript libraries 
Plug 'othree/javascript-libraries-syntax.vim'

" = Python =
" Plug 'heavenshell/vim-pydocstring'

" = Swift =
" File type plugin for the Swift programming language
Plug 'kballard/vim-swift'

call plug#end()

colorscheme nofrils-acme
hi Normal ctermfg=black ctermbg=230 cterm=NONE guifg=#000000 guibg=#fdf6e3 gui=NONE

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ }
" let g:airline_theme='sol'
" let g:airline#extensions#tabline#enabled = 1

runtime plugin/sensible.vim

" Ack.vim
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" Syntastic
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_wq = 0
let g:syntastic_swift_checkers = ['swiftlint']

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" ================ File Formats =====================

" ================ Sources ===========================

" ================ Keybindings =======================

"Dash Plugin mapping
nmap <silent> <leader>d <Plug>DashSearch
" nmap <silent> <leader>d <Plug>(devdocs-under-cursor)

" http://dougblack.io/words/a-good-vimrc.html
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" https://github.com/skwp/dotfiles/blob/master/vimrc
