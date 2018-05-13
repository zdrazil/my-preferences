set encoding=utf-8

set mouse=a
set clipboard^=unnamedplus,unnamed
set wildignorecase

set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set showmatch       " highlight matching [{()}]

set showcmd
set showmode
set number
set title               " e.g. | page.html (~) - VIM | as a windows title

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

Plug 'editorconfig/editorconfig-vim'

" FrontEnd 
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'mxw/vim-jsx'

Plug 'mattn/emmet-vim'

Plug '1995eaton/vim-better-javascript-completion'

call plug#end()

runtime plugin/sensible.vim

" Ack.vim
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
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
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
