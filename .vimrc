" set shell=/bin/bash
set encoding=utf-8

set mouse=a
set wildignorecase
set hidden

set wildmenu
set wildmode=list:longest,list:full

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


set background=light
" Fix colors in tmux
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Make mouse work in tmux
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=sgr
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

Plug 'jeffkreeftmeijer/vim-dim'
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
Plug 'natebosch/vim-lsc'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'ajh17/VimCompletesMe'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
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
Plug 'AndrewRadev/sideways.vim'

Plug 'jpalardy/vim-slime'

Plug 'justinmk/vim-gtfo'

Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'

" FrontEnd
Plug 'suy/vim-context-commentstring'

" Clojure
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'guns/vim-clojure-static'

Plug 'tweekmonster/startuptime.vim'

call plug#end()

runtime plugin/sensible.vim

colorscheme base16-oceanicnext
set background=dark
" colorscheme solarized8
" set background=dark

runtime plugin/grepper.vim
let g:grepper.rg.grepprg .= ' -S '
let g:grepper.tools = ['rg', 'grep', 'git' ]

let g:mapleader = "\<space>"
inoremap jj <Esc>

" " cdc = change to directory of current file
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" fzf
nnoremap <leader>o :FZF<cr>
nnoremap <leader>p :Commands<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>l :Lines<cr>
nnoremap <leader>f :Rg<cr>
nnoremap <leader>h :History:<cr>
nnoremap <leader>ss :Snippets<cr>

" FZF preview
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0)

let g:fzf_layout = { 'down': '40%' }

" let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_eslint_options = "--cache"
let g:ale_javascript_eslint_executable = 'eslint_d'
highlight ALEError ctermbg=none cterm=underline
highlight ALEWarning ctermbg=none cterm=underline

let g:slime_target = "tmux"

let g:highlightedyank_highlight_duration = 200

let g:lsc_auto_map = {
    \ 'GoToDefinition': ['<leader>d', '<leader>gd'],
    \ 'GoToDefinitionSplit': ['<C-W>]', '<C-W><C-]>'],
    \ 'FindReferences': '<leader>grr',
    \ 'NextReference': '<C-n>',
    \ 'PreviousReference': '<C-p>',
    \ 'FindImplementations': '<leader>gI',
    \ 'FindCodeActions': '<leader>gca',
    \ 'Rename': '<leader>grn',
    \ 'ShowHover': '<leader>gh',
    \ 'DocumentSymbol': '<leader>gcs',
    \ 'WorkspaceSymbol': '<leader>gcS',
    \ 'SignatureHelp': '<leader>gy',
    \ 'Completion': 'completefunc',
    \}

let g:lsc_server_commands = {
  \ 'javascript': 'typescript-language-server --stdio',
  \ 'typescript': 'typescript-language-server --stdio',
  \ 'javascriptreact': 'typescript-language-server --stdio',
  \ 'typescriptreact': 'typescript-language-server --stdio',
  \ 'html': 'html-languageserver --stdio',
  \ 'css': 'css-languageserver --stdio',
  \ 'json': 'vscode-json-languageserver --stdio',
	\ 'sh': 'bash-language-server start',
  \ }

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

let g:vimwiki_list = [{'path': '~/vimwiki/',
      \ 'syntax': 'markdown', 'ext': '.md',
      \ 'links_space_char': '-'}
      \]

let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vimwiki_conceallevel = 0
let g:vimwiki_auto_header = 1
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_global_ext = 0

let g:localvimrc_name = [ ".scilvimrc"]
let g:localvimrc_persistent = 2

hi Pmenu ctermbg=Black ctermfg=White

let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'javascriptreact': ['eslint'],
      \ 'typescript': ['eslint'],
      \ 'typescriptreact': ['eslint'],
      \ 'python': ['black'],
      \}

let g:ale_linters = {
      \ 'vimwiki':['writegood'],
      \ 'sh': ['shellcheck'],
      \ 'zsh': ['shellcheck'],
      \ 'bash': ['shellcheck'],
      \ 'javascript': ['eslint', 'tsserver'],
      \ 'javascriptreact': ['eslint', 'tsserver'],
      \ 'typescript': ['eslint', 'tsserver'],
      \ 'typescriptreact': ['eslint', 'tsserver'],
      \}

let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

nmap <leader>gs< <Plug>SidewaysLeft
nmap <leader>gs> <Plug>SidewaysRight

" vimwiki doesn't work nicely with vim vinegar `-` shortcut, so this fixes it
nmap <Nop> <Plug>VimwikiRemoveHeaderLevel

:command! VSCode execute ':silent !code -g %' . ":" . line(".") . ":" . virtcol(".") | execute ':redraw!'
nmap <leader>gov  :VSCode<cr>

if !exists("g:netrw_banner")
  let g:netrw_banner = 1
endif

let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-l>"

autocmd FileType javascript,javascriptreact,typescript,typescriptreact
  \ UltiSnipsAddFiletypes javascript.javascriptreact.typescript.typescriptreact
