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

Plug 'jpalardy/vim-slime'

Plug 'tpope/vim-sensible'
Plug 'jeffkreeftmeijer/vim-dim'

" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'mhinz/vim-grepper'

Plug 'w0rp/ale'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'joaohkfaria/vim-jest-snippets'

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

Plug 'ojroques/vim-oscyank'

Plug 'iberianpig/tig-explorer.vim'

Plug 'editorconfig/editorconfig-vim'
Plug 'markonm/traces.vim'

Plug 'rstacruz/vim-closer'
Plug 'chiedojohn/vim-case-convert'
Plug 'machakann/vim-highlightedyank'
Plug 'AndrewRadev/sideways.vim'

Plug 'justinmk/vim-gtfo'

Plug 'junegunn/vim-peekaboo'

Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'

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

" Make mouse work in tmux
if &term =~# '^screen' || &term =~# '^xterm-kitty'
  " tmux knows the extended mouse mode
  set ttymouse=sgr
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

nmap <silent>gd <Plug>(coc-definition)
nmap gd <Plug>(coc-definition)
nmap <leader>grr <Plug>(coc-references)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>ga <Plug>(coc-codeaction-selected)
xmap <leader>ga <Plug>(coc-codeaction-selected)
nmap <leader>gA <Plug>(coc-codeaction)

nmap <leader>grn <Plug>(coc-rename)

nnoremap <silent><nowait> [c  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> ]c  :<C-u>CocNext<CR>

xmap <silent>v <Plug>(coc-range-select)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)

nnoremap <leader>gh :call <SID>show_documentation()<CR>
nnoremap gh :call <SID>show_documentation()<CR>

nmap <leader>gs< <Plug>SidewaysLeft
nmap <leader>gs> <Plug>SidewaysRight

" file
nnoremap <leader>fve :vsplit $MYVIMRC<cr>
nnoremap <leader>fvs :source $MYVIMRC<cr>

" open
nmap <leader>ov  :OpenInVSCode<cr>

" register
vnoremap <leader>ro :OSCYank<CR>

" search
nnoremap <leader>f :Rg<cr>
nnoremap <leader>> :Grepper -tool rg<CR>
nnoremap <leader>. :Rg<cr>
nnoremap <silent><nowait> <leader>scs  :<C-u>CocList snippets<cr>

let g:ale_javascript_eslint_executable = 'eslint_d'
" let g:ale_javascript_eslint_options = '--cache'
let g:ale_javascript_eslint_use_global = 1

let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_disable_lsp = 1

let g:highlightedyank_highlight_duration = 100

" Coc.nvim
let g:coc_global_extensions = [
      \ 'coc-emmet',
      \ 'coc-json',
      \ 'coc-tsserver',
      \ ]
      " \ 'coc-snippets',

set updatetime=300

inoremap <silent><expr> <c-space> coc#refresh()
imap <C-@> <C-Space>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction

imap <C-l> <Plug>(coc-snippets-expand)
imap <C-j> <Plug>(coc-snippets-expand-jump)

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
  autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
augroup END

