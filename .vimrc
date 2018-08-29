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

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

" Plug 'robertmeta/nofrils'
Plug 'altercation/vim-colors-solarized'
" Plug 'vim-scripts/CycleColor'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'mileszs/ack.vim'
Plug 'ludovicchabant/vim-gutentags'

Plug 'w0rp/ale'

Plug 'ajh17/VimCompletesMe'

Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'

Plug 'editorconfig/editorconfig-vim'
Plug 'markonm/traces.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'mhinz/vim-signify'

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
let g:gutentags_file_list_command = 'rg --files'
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
" let g:ale_completion_enabled = 1
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

nnoremap <leader>] :ALEGoToDefinition<cr>

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
