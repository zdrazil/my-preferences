set guicursor=
set mouse=a
set wildignorecase

set wildmode=list:longest,list:full

" Highlight searches by default
set ignorecase
set smartcase
set incsearch
" highlight matching [{()}]
set showmatch

set showmode
set number
" e.g. | page.html (~) - VIM | as a windows title
set title

set breakindent
let &showbreak = '> '
set linebreak

set cmdheight=2

" always show gutter so it doesn't move
set signcolumn=yes

call plug#begin(stdpath('data') . '/plugged')

" Themes
Plug 'vimwiki/vimwiki'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

Plug 'markonm/traces.vim'
Plug 'justinmk/vim-gtfo'

Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'

call plug#end()

let g:mapleader = "\<space>"

let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-emmet',
      \ 'coc-emoji',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-pyright',
      \ 'coc-react-refactor',
      \ 'coc-snippets',
      \ 'coc-sql',
      \ 'coc-tabnine',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ ]

let g:vimwiki_list = [{
      \ 'path': '~/Dropbox/wiki/',
      \ 'syntax': 'markdown', 
      \ 'ext': '.md',
      \ 'links_space_char': '-',
      \},
      \{
      \ 'path': '~/OneDrive/wiki',
      \ 'syntax': 'markdown', 
      \ 'ext': '.md',
      \ 'links_space_char': '-',
      \}]

let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vimwiki_conceallevel = 0
let g:vimwiki_auto_header = 1
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_global_ext = 0

let g:sneak#use_ic_scs = 1

function SlimeOverride_EscapeText_typescript(text)
  return system('js-require', a:text)
endfunction

function SlimeOverride_EscapeText_javascript(text)
  return system('js-require', a:text)
endfunction

if exists('$EXTRA_VIM')
  for path in split($EXTRA_VIM, ':')
    exec 'source '.path
  endfor
endif

" Higlight yank
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=50}
