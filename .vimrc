set encoding=utf-8

set mouse=a
set wildignorecase
set hidden

set wildmenu
set wildmode=list:longest,list:full

set hlsearch
set ignorecase
set smartcase
set showmatch

set showcmd
set showmode
set number
set title

set breakindent
let &showbreak = '> '
set linebreak

set incsearch
set cmdheight=2

" always show gutter so it doesn't move
set signcolumn=yes

let undodir = expand('~/.vim/undo')
if !isdirectory(undodir)
  call mkdir(undodir)
endif

let swapdir = expand('~/.vim/swap')
if !isdirectory(swapdir)
  call mkdir(swapdir)
endif

let backupdir = expand('~/.vim/backup')
if !isdirectory(backupdir)
  call mkdir(backupdir)
endif

set directory=~/.vim/swap//
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//

let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'
Plug 'lifepillar/vim-solarized8'

Plug 'tpope/vim-sensible'
Plug 'jeffkreeftmeijer/vim-dim'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'mhinz/vim-grepper'

Plug 'w0rp/ale'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

Plug 'ojroques/vim-oscyank', {'branch': 'main'}

Plug 'iberianpig/tig-explorer.vim'

Plug 'editorconfig/editorconfig-vim'
Plug 'markonm/traces.vim'

Plug 'rstacruz/vim-closer'
Plug 'chiedojohn/vim-case-convert'
Plug 'machakann/vim-highlightedyank'

Plug 'justinmk/vim-gtfo'

Plug 'junegunn/vim-peekaboo'

Plug 'justinmk/vim-sneak'
Plug 'michaeljsmith/vim-indent-object'
Plug 'terryma/vim-expand-region'

" FrontEnd
Plug 'suy/vim-context-commentstring'

Plug 'tweekmonster/startuptime.vim' , { 'on': 'StartupTime' }

call plug#end()

runtime plugin/sensible.vim

colorscheme dim

if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

if g:os ==# 'Darwin'
  if system('defaults read -g AppleInterfaceStyle') =~# '^Dark'
    set background=dark   " for the dark version of the theme
  else
    set background=light  " for the light version of the theme
  endif
else
  if $BACKGROUND_THEME ==# 'dark'
    set background=dark
  endif
endif

runtime plugin/grepper.vim
let g:grepper.rg.grepprg .= ' -S '
let g:grepper.tools = ['rg', 'grep', 'git' ]
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

let g:mapleader = "\<space>"
inoremap jj <Esc>

" Leader maps
nnoremap <leader><leader> :FZF<cr>
nnoremap <leader>; :Commands<cr>

" buffer
nnoremap <leader>bb :Buffers<cr>

nmap <leader>gx :ALEDetail<CR>

nmap gd :ALEGoToDefinition<CR>
nmap <leader>grr :ALEFindReferences -quickfix<CR> :copen<CR>
nmap <leader>gy :ALEGoToDefinition<CR>
nmap <leader>ga :ALECodeAction<CR>
xmap <leader>ga :ALECodeAction<CR>
nmap <leader>gA :ALECodeAction<CR>
nmap <leader>gfi <Plug>(ale_import)

nmap <leader>grn :ALERename<CR>

nnoremap <silent> [c <Plug>(ale_previous_wrap)
nnoremap <silent> ]c <Plug>(ale_next_wrap) 

xmap <silent>v <Plug>(expand_region_expand)

nnoremap <leader>gh <Plug>(ale_hover)
nnoremap gh <Plug>(ale_hover)

nmap <leader>gs< <Plug>SidewaysLeft
nmap <leader>gs> <Plug>SidewaysRight

" file
nnoremap <leader>fve :vsplit $MYVIMRC<cr>
nnoremap <leader>fvs :source $MYVIMRC<cr>

" open
nmap <leader>ov  :OpenInVSCode<cr>

" register
vnoremap <leader>ro <Plug>OSCYankVisual

" search
nnoremap <leader>f :Rg<cr>
nnoremap <leader>> :Grepper -tool rg<CR>
nnoremap <leader>. :Rg<cr>

set omnifunc=ale#completion#OmniFunc
set completeopt=menu,menuone,popup,noselect,noinsert

let g:ale_disable_lsp = 0
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_floating_preview = 1
let g:ale_linters_explicit = 1
let g:ale_virtualtext_cursor = 'disabled'

let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_options = '--cache'
let g:ale_javascript_eslint_use_global = 1

let g:highlightedyank_highlight_duration = 100

set updatetime=300

" inoremap <silent><expr> <c-space> coc#refresh()
imap <C-@> <C-Space>

let g:ale_fixers = {
      \ 'haskell': ['ormolu'],
      \ 'javascript': ['eslint', 'prettier'],
      \ 'javascriptreact': ['eslint', 'prettier'],
      \ 'python': ['black'],
      \ 'rust': ['rustfmt'],
      \ 'sh': ['shfmt'],
      \ 'typescript': ['eslint', 'prettier'],
      \ 'typescriptreact': ['eslint', 'prettier'],
      \}

let g:ale_linters = {
      \ 'javascript': ['eslint', 'tsserver'],
      \ 'javascriptreact': ['eslint', 'tsserver'],
      \ 'sh': ['shellcheck'],
      \ 'typescript': ['eslint', 'tsserver'],
      \ 'typescriptreact': ['eslint', 'tsserver'],
      \}


:command! VSCode execute ':silent !code -g %' . ":" . line(".") . ":" . virtcol(".") | execute ':redraw!'
:command! OpenInVSCode execute "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
:command! WebStorm execute ':silent !webstorm' . " --line " . line(". ") . " --column " . virtcol("."). ' %' | execute ':redraw!'

let g:netrw_banner = 1

command YankPath execute ':let @+ = expand("%")'

let g:peekaboo_delay=400

if exists('$EXTRA_VIM')
  for path in split($EXTRA_VIM, ':')
    exec 'source '.path
  endfor
endif

augroup MYOSCYank
  autocmd TextYankPost *
    \ if v:event.operator is 'y' && v:event.regname is '+' |
    \ execute 'OSCYankRegister +' |
    \ endif
augroup END

call expand_region#custom_text_objects({
      \ 'a]' :1,
      \ 'a<' :1,
      \ 'ab' :1,
      \ 'aB' :1,
      \ })

      let g:ale_completion_enabled = 1
