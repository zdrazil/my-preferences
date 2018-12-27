set encoding=utf-8

set mouse=a
set clipboard^=unnamedplus,unnamed
set wildignorecase
set hidden

set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set showmatch       " highlight matching [{()}]

set showcmd
set showmode
set number
set title               " e.g. | page.html (~) - VIM | as a windows title

set completeopt=longest,menuone

set background=dark
" set termguicolors

silent !mkdir ~/.vim/undo > /dev/null 2>&1
silent !mkdir ~/.vim/backup > /dev/null 2>&1
silent !mkdir ~/.vim/swap > /dev/null 2>&1
set undodir=~/.vim/undo//
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

" Plug 'robertmeta/nofrils'
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/CycleColor'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'mileszs/ack.vim'
Plug 'mhinz/vim-grepper'

Plug 'w0rp/ale'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
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

Plug 'editorconfig/editorconfig-vim'
Plug 'markonm/traces.vim'
" Plug 'nelstrom/vim-visual-star-search'
Plug 'mhinz/vim-signify'

Plug 'rstacruz/vim-closer'
Plug 'chiedojohn/vim-case-convert'
Plug 'machakann/vim-highlightedyank'

Plug 'sheerun/vim-polyglot'
Plug 'jpalardy/vim-slime'

Plug 'rizzatti/dash.vim'

" FrontEnd 
Plug 'galooshi/vim-import-js'
Plug 'moll/vim-node'
Plug 'ryanolsonx/vim-lsp-typescript'

Plug 'mattn/emmet-vim'

call plug#end()

runtime plugin/sensible.vim

" colorscheme solarized
" colorscheme solarized8

colorscheme gruvbox
" dark mode enabled?
if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
   set background=dark
else
  set background=light
endif

let g:grepper = {}
let g:grepper.tools = ['rg','grep', 'git' ]

let g:mapleader = "\<Space>"
inoremap <C-Space> <Space> 

" CDC = Change to Directory of Current file
command CDC cd %:p:h

" FZF
nnoremap <leader>o :FZF<cr>
nnoremap <leader>p :Commands<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>/ :Lines<cr>

let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 1

let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

let g:javascript_plugin_flow = 1

let g:slime_target = "vimterminal"

let g:highlightedyank_highlight_duration = 200 

" LSP
nnoremap <leader>] :LspDefinition<cr>

nnoremap <Leader>* :Grepper -cword -noprompt<CR>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

nnoremap <Leader>g :Grepper -tool rg<CR>

:nmap <silent> <leader>d <Plug>DashSearch

" Project settings
augroup ProjectSetup
    au BufRead,BufEnter ~/projects/zindulka/customer-zone/* 
                \let g:ale_fixers = {
                \ 'javascript': ['prettier', 'eslint'],
                \ 'json': ['prettier', 'eslint'],
                \ 'scss': ['prettier', 'stylelint'],
                \} |
                \let g:ale_linters = {
                \ 'javascript': ['eslint'],
                \ 'scss': ['stylelint'],
                \}
    au BufRead,BufEnter ~/projects/zindulka/advent-of-code/* 
                \let g:ale_fixers = {
                \ 'javascript': ['prettier', 'eslint'],
                \ 'json': ['prettier', 'eslint'],
                \ 'scss': ['prettier', 'stylelint'],
                \} |
                \let g:ale_linters = {
                \ 'javascript': ['eslint'],
                \ 'scss': ['stylelint'],
                \}
    au BufRead,BufEnter /path/to/project2/* set noet sts=4 cindent cinoptions=...
augroup END

" Projectionist
" Dash

" Language servers
if executable('css-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'css-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
        \ 'whitelist': ['css', 'less', 'sass'],
        \ })
endif

if executable('flow')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'flow',
        \ 'cmd': {server_info->['flow', 'lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
endif

" if executable('typescript-language-server')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'typescript-language-server',
"         \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
"         \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
"         \ 'whitelist': ['typescript'],
"         \ })
" endif

if executable('typescript-language-server')
    autocmd FileType typescript setlocal omnifunc=lsp#complete
endif


if executable('flow')
    autocmd FileType javascript setlocal omnifunc=lsp#complete
    autocmd FileType javascript.jsx setlocal omnifunc=lsp#complete
endif

if executable('hie')
    autocmd FileType haskell setlocal omnifunc=lsp#complete
endif

if executable('hie')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'hie',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'hie-wrapper --lsp']},
        \ 'whitelist': ['haskell'],
        \ })
endif

