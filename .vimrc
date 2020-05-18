set shell=/bin/bash
set encoding=utf-8

set mouse=a
set clipboard^=unnamedplus,unnamed
set wildignorecase
set hidden

set hlsearch        " Highlight searches by default
set ignorecase
set smartcase
set showmatch       " highlight matching [{()}]

set showcmd
set showmode
set number
set title               " e.g. | page.html (~) - VIM | as a windows title

set breakindent
let &showbreak = '> '
set linebreak

set ignorecase
set smartcase
" set completeopt=longest,menuone


set cmdheight=2

set background=dark
" set termguicolors

" always show gutter so it doesn't move
set signcolumn=yes 

silent !mkdir ~/.vim/undo > /dev/null 2>&1
silent !mkdir ~/.vim/backup > /dev/null 2>&1
silent !mkdir ~/.vim/swap > /dev/null 2>&1
set undodir=~/.vim/undo//
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

Plug 'embear/vim-localvimrc'

Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/CycleColor'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'mileszs/ack.vim'
Plug 'mhinz/vim-grepper'

Plug 'w0rp/ale'

Plug 'sheerun/vim-polyglot'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ajh17/VimCompletesMe'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'


" Fugitive extensions
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'

Plug 'editorconfig/editorconfig-vim'
Plug 'markonm/traces.vim'
" Plug 'nelstrom/vim-visual-star-search'
Plug 'mhinz/vim-signify'

Plug 'rstacruz/vim-closer'
Plug 'chiedojohn/vim-case-convert'
Plug 'machakann/vim-highlightedyank'

Plug 'jpalardy/vim-slime'

Plug 'Shougo/echodoc.vim'

" Plug 'ludovicchabant/vim-gutentags'

" FrontEnd 
Plug 'galooshi/vim-import-js'
Plug 'moll/vim-node'
Plug 'suy/vim-context-commentstring'
" Plug 'kristijanhusak/vim-js-file-import'

Plug 'mattn/emmet-vim'

" Clojure
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'guns/vim-clojure-static'
Plug 'tpope/vim-salve'

call plug#end()

runtime plugin/sensible.vim

" colorscheme solarized
" colorscheme solarized8

colorscheme gruvbox

runtime plugin/grepper.vim
" let g:grepper.prompt_quote = 1 
let g:grepper.rg.grepprg .= ' -S '
let g:grepper.tools = ['rg', 'grep', 'git' ]
nnoremap <leader>* :Grepper -tool git -open -switch -cword -noprompt<cr>

let g:mapleader = "\<space>"
" inoremap <c-space> <space> 
inoremap jj <Esc>

" " cdc = change to directory of current file
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" fzf
nnoremap <leader>o :FZF<cr>
nnoremap <leader>p :Commands<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>/ :Lines<cr>
nnoremap <leader>f :Rg<cr>

" FZF preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

let g:dispatch_compilers = {
  \ 'yeslint': 'yeslint',
  \ 'ytsc': 'ytsc'}

let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_javascript_eslint_options = "--cache"

let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

" let g:javascript_plugin_flow = 1

let g:slime_target = "tmux"

let g:highlightedyank_highlight_duration = 200 

" Coc.nvim
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-eslint',
  \ 'coc-fsharp',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-stylelint',
  \ 'coc-tsserver',
  \ 'coc-tsserver',
  \ ]

set updatetime=300
inoremap <silent><expr> <c-space>a coc#refresh()

nmap <leader>d <Plug>(coc-definition)
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)

nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)

nmap <leader>[c <Plug>(coc-diagnostic-prev)
nmap <leader>]c <Plug>(coc-diagnostic-next)

nmap <leader>gca <Plug>(coc-codeaction)

nmap <leader>grn <Plug>(coc-rename)

inoremap <silent><expr> <c-space> coc#refresh()
imap <C-@> <C-Space>


nnoremap <leader>gh :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nnoremap <Leader>F :Grepper -tool rg<CR>

nnoremap <leader>ev :vsplit $MYVIMRC<cr> " Edit my Vimrc
nnoremap <leader>sv :source $MYVIMRC<cr> " Source my Vimrc

let s:clip = '/mnt/c/Windows/System32/clip.exe' 
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\<CR>")).' | '.s:clip)
    augroup END
end

let g:localvimrc_whitelist=['/mnt/c/Users/Vladimir/projects/linux/mews-js/.*', '/home/zdrazil/projects/mews/mews-js/.*', 'Users/mews/projects/mews-js/.*', 'Users/zdrazil/projects/mews-js/.*']

let g:typescript_compiler_binary = 'yarn tsc'

" let g:ale_fixers = {
"             \ 'haskell': ['brittany'],
"             \ 'javascript': ['eslint'],
"             \ 'json': ['prettier', 'eslint'],
"             \ 'scss': ['prettier', 'stylelint'],
"             \ 'typescript': ['tslint'],
"             \}

" let g:ale_linters = {
"             \ 'haskell': ['hie'],
"             \ 'javascript': ['eslint', 'tsserver'],
"             \ 'json': ['eslint'],
"             \ 'scss': ['stylelint'],
"             \ 'typescript': ['tslint', 'tsserver'],
"             \}
