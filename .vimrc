" ================ General Config ====================
set hidden
set encoding=utf-8

" let macvim_skip_colorscheme=1
" set background=light

" ================ Indentation ======================
" set cursorline

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
if has('persistent_undo')
    set undodir=~/.undodir/
    set undofile
endif

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
" Plug 'robertmeta/nofrils'
Plug 'altercation/vim-colors-solarized'
" Plug 'chriskempson/base16-vim'
" Plug 'vim-scripts/CycleColor'

" === File and project management ===
" == Searching ==
" Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
" Plug 'https://github.com/ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" A tree explorer plugin
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Use ack instead of grep
Plug 'mileszs/ack.vim'

" Undo history visualizer
Plug 'mbbill/undotree'

" === Documentation ===
" Auto generate ctags
Plug 'ludovicchabant/vim-gutentags'

" Look Up Documentation 
Plug 'rizzatti/dash.vim'
" Plug 'rhysd/devdocs.vim'
" Plug 'keith/investigate.vim'

" === Editing ===
" Syntax checking plugin
" Plug 'https://github.com/vim-syntastic/syntastic'
Plug 'w0rp/ale'

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
" Better whitespace highlighting and stripping
Plug 'ntpeters/vim-better-whitespace'

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

" colorscheme nofrils-acme
" hi Normal ctermfg=black ctermbg=230 cterm=NONE guifg=#000000 guibg=#fdf6e3 gui=NONE

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ }
" let g:airline_theme='sol'
" let g:airline#extensions#tabline#enabled = 1

runtime plugin/sensible.vim

" Ack.vim
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
    " let g:ackprg = 'rg --vimgrep --no-heading'
endif

" Ale
augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
augroup END

let g:ale_linters = {
\   'javascript': ['eslint']
\}
let g:ale_fixers = {
\   'javascript': ['eslint'],
\}

" Syntastic
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_swift_checkers = ['swiftlint']
let g:syntastic_javascript_checkers = ['eslint']
" https://github.com/vim-syntastic/syntastic/issues/1692#issuecomment-241672883
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" ================ File Formats =====================

" ================ Sources ===========================

" ================ Keybindings =======================
let g:mapleader = "\<Space>"
inoremap <C-Space> <Space>

"Dash Plugin mapping
nmap <silent> <leader>d <Plug>DashSearch
" nmap <silent> <leader>d <Plug>(devdocs-under-cursor)
" FZF
nnoremap <leader>o :FZF<cr>
nnoremap <leader>p :Commands<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>/ :Lines<cr>

" NerdTree
noremap <leader>e :NERDTreeToggle<CR>

" YouCompleteMe
nnoremap <Leader>] :YcmCompleter GoTo<CR>

" ================ Commands =========================


" http://dougblack.io/words/a-good-vimrc.html
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" https://github.com/skwp/dotfiles/blob/master/vimrc
