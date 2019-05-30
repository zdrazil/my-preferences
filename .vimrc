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

set cmdheight=2

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

" Plug 'LucHermitte/lh-vim-lib'
" Plug 'LucHermitte/local_vimrc'
Plug 'embear/vim-localvimrc'

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

Plug 'sheerun/vim-polyglot'

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

Plug 'jpalardy/vim-slime'

Plug 'rizzatti/dash.vim'
Plug 'Shougo/echodoc.vim'

" FrontEnd 
Plug 'galooshi/vim-import-js'
Plug 'moll/vim-node'
" Plug 'ryanolsonx/vim-lsp-typescript'

Plug 'mattn/emmet-vim'

" Clojure
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

call plug#end()

runtime plugin/sensible.vim

" colorscheme solarized
" colorscheme solarized8

colorscheme gruvbox

runtime plugin/grepper.vim
let g:grepper.prompt_quote = 1 
let g:grepper.rg.grepprg .= ' -s --'
let g:grepper.tools = ['rg', 'grep', 'git' ]

let g:mapleader = "\<space>"
inoremap <c-space> <space> 
inoremap jj <Esc>

" " cdc = change to directory of current file
" command cdc cd %:p:h

" fzf
nnoremap <leader>o :FZF<cr>
nnoremap <leader>p :Commands<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>/ :Lines<cr>

let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1

let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

let g:javascript_plugin_flow = 1

let g:slime_target = "tmux"

let g:highlightedyank_highlight_duration = 200 

" LSP
nnoremap <leader>] :LspDefinition<cr>

nnoremap <Leader>* :Grepper -cword -noprompt<CR>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

nnoremap <Leader>g :Grepper -tool rg<CR>

nnoremap <Leader>h :LspHover<CR>

" :nmap <silent> <leader>d <Plug>DashSearch

nnoremap <leader>ev :vsplit $MYVIMRC<cr> " Edit my Vimrc
nnoremap <leader>sv :source $MYVIMRC<cr> " Source my Vimrc

" func! GetSelectedText()
"     normal gv"xy
"     let result = getreg("x")
"     return result
" endfunc

" if !has("clipboard") && executable("clip.exe")
"     noremap <C-C> :call system('clip.exe', GetSelectedText())<CR>
"     noremap <C-X> :call system('clip.exe', GetSelectedText())<CR>gvx
" endif

let s:clip = '/mnt/c/Windows/System32/clip.exe' 
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\<CR>")).' | '.s:clip)
    augroup END
end

let g:localvimrc_whitelist=['/mnt/c/Users/Vladimir/projects/linux/mews-js/.*']


let g:ale_fixers = {
            \ 'javascript': ['prettier', 'eslint'],
            \ 'json': ['prettier', 'eslint'],
            \ 'scss': ['prettier', 'stylelint'],
            \ 'haskell': ['brittany'],
            \}

let g:ale_linters = {
            \ 'javascript': ['eslint'],
            \ 'json': ['eslint'],
            \ 'scss': ['stylelint'],
            \ 'haskell': ['hie'],
            \}

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

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx'],
        \ })
endif

if executable('typescript-language-server')
    autocmd FileType typescript setlocal omnifunc=lsp#complete
    autocmd FileType typescript.tsx setlocal omnifunc=lsp#complete
    autocmd FileType javascript setlocal omnifunc=lsp#complete
    autocmd FileType javascript.jsx setlocal omnifunc=lsp#complete
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

