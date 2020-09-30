" set shell=/bin/bash
set encoding=utf-8

set mouse=a
set wildignorecase
set hidden

" Highlight searches by default
set hlsearch
set ignorecase
set smartcase
" highlight matching [{()}]
set showmatch

set showcmd
set showmode
set number
" e.g. | page.html (~) - VIM | as a windows title
set title

set breakindent
let &showbreak = '> '
set linebreak

" set completeopt=longest,menuone

set cmdheight=2

" set background=light
" Fix colors in tmux
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

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

" Themes
Plug 'vim-scripts/CycleColor'
Plug 'robertmeta/nofrils'
Plug 'https://gitlab.com/protesilaos/tempus-themes-vim.git'

Plug 'lifepillar/vim-gruvbox8'
Plug 'lifepillar/vim-solarized8'
Plug 'chriskempson/base16-vim'

Plug 'jan-warchol/selenized'
Plug 'zefei/cake16'
Plug 'plan9-for-vimspace/acme-colors'
Plug 'andreasvc/vim-256noir'
Plug 'Lokaltog/vim-monotone'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'mhinz/vim-grepper'

Plug 'vimwiki/vimwiki'

Plug 'sheerun/vim-polyglot'

Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'ajh17/VimCompletesMe'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-apathy'
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
Plug 'tpope/vim-obsession'

Plug 'editorconfig/editorconfig-vim'
Plug 'markonm/traces.vim'
Plug 'junegunn/vim-easy-align'


Plug 'rstacruz/vim-closer'
Plug 'chiedojohn/vim-case-convert'
Plug 'machakann/vim-highlightedyank'
" Plug 'tommcdo/vim-exchange'
Plug 'AndrewRadev/sideways.vim'

Plug 'jpalardy/vim-slime'

Plug 'rhysd/devdocs.vim'
Plug 'justinmk/vim-gtfo'

Plug 'justinmk/vim-sneak'

" FrontEnd
Plug 'suy/vim-context-commentstring'

Plug 'mattn/emmet-vim'

" Clojure
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'guns/vim-clojure-static'
Plug 'tpope/vim-salve'

Plug 'tweekmonster/startuptime.vim'

call plug#end()

runtime plugin/sensible.vim

" dark mode enabled?
if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
  colorscheme solarized8
  set background=dark
else
  " colorscheme gruvbox-high
  colorscheme base16-gruvbox-light-medium
  " colorscheme nofrils-acme
  " colorscheme monotone
  set background=light
endif

runtime plugin/grepper.vim
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
nnoremap <leader>l :Lines<cr>
nnoremap <leader>f :Rg<cr>

" FZF preview
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

let g:fzf_layout = { 'down': '40%' }

command FoldIndent setlocal foldmethod=indent
command FoldManual setlocal foldmethod=manual
command FoldSyntax setlocal foldmethod=syntax

" let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_javascript_eslint_options = "--cache"
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_disable_lsp = 1

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
      \ 'coc-emmet',
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

nnoremap <silent><nowait> <leader>gcs  :<C-u>CocList -I symbols<cr>

nnoremap <silent><nowait> <leader>gco  :<C-u>CocList outline<cr>


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

autocmd CursorHold * silent call CocActionAsync('highlight')


nnoremap <Leader>F :Grepper -tool rg<CR>
nmap <Leader>gs  <plug>(GrepperOperator)
xmap <Leader>gs  <plug>(GrepperOperator)

nmap <Leader>gk <Plug>(devdocs-under-cursor)

nnoremap <leader>ev :vsplit $MYVIMRC<cr> " Edit my Vimrc
nnoremap <leader>sv :source $MYVIMRC<cr> " Source my Vimrc

nnoremap <Leader>/ /\%><C-R>=line('w0')-1<CR>l\%<<C-R>=line('w$')+1<CR>l

let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
  augroup WSLYank
    autocmd!
    autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\<CR>")).' | '.s:clip)
  augroup END
end

let g:vimwiki_list = [{'path': '~/vimwiki/',
      \ 'syntax': 'markdown', 'ext': '.md',
      \ 'links_space_char': '-'}
      \]

let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vimwiki_conceallevel = 0
let g:vimwiki_auto_header = 1

" let g:zettel_format = "%y%m%d-%H%M%S"

let g:localvimrc_name = [ ".scilvimrc"]
let g:localvimrc_persistent = 2

hi Pmenu ctermbg=Black ctermfg=White

" augroup plugin-devdocs
"   autocmd!
"   autocmd FileType
"         \ haskell,
"         \ javascript,
"         \ javascriptreact,
"         \ python,
"         \ typescript,
"         \ typescriptreact
"         \ nmap <buffer>K <Plug>(devdocs-under-cursor)
" augroup END

let g:ale_fixers = {
      \ 'haskell': ['hlint', 'brittany'],
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint'],
      \}

let g:ale_linters = {
      \ 'haskell': ['hlint'],
      \ 'javascript': ['eslint', 'tsserver'],
      \ 'typescript': ['eslint', 'tsserver'],
      \}

let g:sneak#label = 1

nmap <leader>gs< <Plug>SidewaysLeft
nmap <leader>gs> <Plug>SidewaysRight

" vimwiki doesn't work nicely with vim vinegar `-` shortcut, so this fixes it
nmap <Nop> <Plug>VimwikiRemoveHeaderLevel

