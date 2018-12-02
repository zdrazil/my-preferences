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

set background=dark

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
" Plug 'vim-scripts/CycleColor'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'mileszs/ack.vim'
" Plug 'ludovicchabant/vim-gutentags'

Plug 'w0rp/ale'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'

Plug 'ryanolsonx/vim-lsp-python'
Plug 'ryanolsonx/vim-lsp-typescript'

" Plug 'ajh17/VimCompletesMe'

Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'

Plug 'editorconfig/editorconfig-vim'
Plug 'markonm/traces.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'mhinz/vim-signify'

Plug 'chiedojohn/vim-case-convert'

" FrontEnd 
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'mxw/vim-jsx'
Plug 'galooshi/vim-import-js'

Plug 'mattn/emmet-vim'

" Plug '1995eaton/vim-better-javascript-completion'

call plug#end()

runtime plugin/sensible.vim

" Ack.vim
if executable('rg')
    let g:ackprg = 'rg --vimgrep --no-heading'
endif

let g:mapleader = "\<Space>"
inoremap <C-Space> <Space> 

" FZF
nnoremap <leader>o :FZF<cr>
nnoremap <leader>p :Commands<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>/ :Lines<cr>

" Gutentags
" let g:gutentags_file_list_command = 'rg --files'
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
" let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
" let g:javascript_plugin_flow = 1
" let g:javascript_plugin_jsdoc = 1

" LSP
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

nnoremap <leader>] :LspDefinition<cr>

" Project settings
augroup ProjectSetup
    au BufRead,BufEnter ~/projects/zindulka/customer-zone/* 
                \let g:ale_fixers = {
                \ 'javascript': ['prettier', 'eslint'],
                \ 'json': ['prettier', 'eslint'],
                \ 'scss': ['prettier', 'stylelint'],
                \} |
                \let g:ale_linters = {
                \ 'javascript': ['eslint', 'flow', 'flow-language-server'],
                \ 'scss': ['stylelint'],
                \}
    au BufRead,BufEnter /path/to/project2/* set noet sts=4 cindent cinoptions=...
augroup END

" Asyncomplete
set completeopt+=preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

" Language servers

if executable('flow')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'flow',
        \ 'cmd': {server_info->['flow', 'lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
endif

if executable('css-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'css-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
        \ 'whitelist': ['css', 'less', 'sass'],
        \ })
endif

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'typescript-language-server',
      \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'whitelist': ['typescript', 'javascript', 'javascript.jsx']
      \ })
endif


if executable('html-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'html-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'html-languageserver --stdio']},
        \ 'whitelist': ['html'],
        \ })
endif

