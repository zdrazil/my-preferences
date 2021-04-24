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

set incsearch

" set completeopt=longest,menuone

set cmdheight=2

" Fix colors in tmux, set better 24bit colors if supported
if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit')
  " Enable true color in Vim on tmux (not necessary for NeoVim)
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

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

Plug 'embear/vim-localvimrc'

" Themes
Plug 'vim-scripts/CycleColor', { 'on': ['CycleColorNext', 'CycleColorPrev'] }
Plug 'robertmeta/nofrils'
Plug 'https://gitlab.com/protesilaos/tempus-themes-vim.git'

Plug 'lifepillar/vim-gruvbox8'
Plug 'lifepillar/vim-solarized8'
Plug 'chriskempson/base16-vim'

Plug 'jeffkreeftmeijer/vim-dim'
Plug 'noahfrederick/vim-noctu'
Plug 'jan-warchol/selenized'
Plug 'zefei/cake16'
Plug 'plan9-for-vimspace/acme-colors'
Plug 'andreasvc/vim-256noir'
Plug 'Lokaltog/vim-monotone'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'mhinz/vim-grepper'

Plug 'vimwiki/vimwiki'

" Starts slower
" Plug 'sheerun/vim-polyglot'

Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'SirVer/ultisnips'
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

" Plug 'dhruvasagar/vim-prosession'

Plug 'editorconfig/editorconfig-vim'
Plug 'markonm/traces.vim'
Plug 'junegunn/vim-easy-align'

Plug 'rstacruz/vim-closer'
Plug 'chiedojohn/vim-case-convert'
Plug 'machakann/vim-highlightedyank'
Plug 'AndrewRadev/sideways.vim'
Plug 'ludovicchabant/vim-gutentags'

Plug 'jpalardy/vim-slime'

Plug 'justinmk/vim-gtfo'

Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'

" FrontEnd
Plug 'suy/vim-context-commentstring'

" Clojure
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-sexp', { 'for': ['clojure', 'scheme'] }
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'guns/vim-clojure-static'

" C#
Plug 'OmniSharp/omnisharp-vim'

Plug 'tweekmonster/startuptime.vim'

call plug#end()

runtime plugin/sensible.vim

if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit') || has("gui_running")
  if $USER == 'mews'
    colorscheme solarized8
  else
    colorscheme base16-oceanicnext
  endif
else 
    colorscheme noctu
endif

set background=dark

runtime plugin/grepper.vim
let g:grepper.rg.grepprg .= ' -S '
let g:grepper.tools = ['rg', 'grep', 'git' ]
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

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
imap <c-x><c-l> <plug>(fzf-complete-line)

" " FZF preview
" command! -bang -nargs=* Rg
"     \ call fzf#vim#grep(
"     \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
"     \   <bang>0 ? fzf#vim#with_preview('up:60%')
"     \           : fzf#vim#with_preview('right:50%:hidden', '?'),
"     \   <bang>0)

let g:fzf_layout = { 'down': '40%' }

" let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_eslint_options = "--cache"
let g:ale_javascript_eslint_executable = 'eslint_d'
highlight ALEError ctermbg=none cterm=underline
highlight ALEWarning ctermbg=none cterm=underline

let g:slime_target = "vimterminal"

let g:highlightedyank_highlight_duration = 200

nnoremap <leader>ev :vsplit $MYVIMRC<cr> " Edit my Vimrc
nnoremap <leader>sv :source $MYVIMRC<cr> " Source my Vimrc

" Coc.nvim
let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-perl',
      \ 'coc-sql',
      \ 'coc-fsharp',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-emmet',
      \ 'coc-pyright',
      \ 'coc-snippets',
      \ 'coc-lines',
      \ 'coc-tag',
      \ ]

set updatetime=300

nmap <leader>d <Plug>(coc-definition)
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)

nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>grr <Plug>(coc-references)

nmap <leader>[c <Plug>(coc-diagnostic-prev)
nmap <leader>]c <Plug>(coc-diagnostic-next)

nmap <leader>gca <Plug>(coc-codeaction-selected)
xmap <leader>gca <Plug>(coc-codeaction-selected)
nmap <leader>gcA <Plug>(coc-codeaction)

nmap <leader>grn <Plug>(coc-rename)

nnoremap <silent><nowait> <leader>gcs  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <leader>ss  :<C-u>CocList snippets<cr>
nnoremap <silent><nowait> <leader>gco  :<C-u>CocList outline<cr>

command! -nargs=0 CocFormat :call CocAction('format')

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

imap <C-l> <Plug>(coc-snippets-expand)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" coc-omnisharp can't go to definition of Microsoft packages, so use
" omnisharp-vim
" autocmd FileType cs nnoremap <buffer><leader>gd :OmniSharpGotoDefinition<CR>

augroup omnisharp_commands
  autocmd!

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> <Leader>gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>gy <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>grr <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>gi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>gh <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>gcs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>gca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>gca <Plug>(omnisharp_code_actions)
  autocmd FileType cs nmap <silent> <buffer> <Leader>grn <Plug>(omnisharp_rename)
augroup END

let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
  augroup WSLYank
    autocmd!
    autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\<CR>")).' | '.s:clip)
  augroup END
end

let g:vimwiki_list = [{
      \ 'path': '~/vimwiki/',
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
      \ 'cs': ['OmniSharp'],
      \ 'vimwiki':['writegood'],
      \ 'sh': ['shellcheck'],
      \ 'zsh': ['shellcheck'],
      \ 'bash': ['shellcheck'],
      \ 'javascript': ['eslint', 'tsserver'],
      \ 'javascriptreact': ['eslint', 'tsserver'],
      \ 'python': ['flake8'],
      \ 'typescript': ['eslint', 'tsserver'],
      \ 'typescriptreact': ['eslint', 'tsserver'],
      \}

let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

nmap <leader>gs< <Plug>SidewaysLeft
nmap <leader>gs> <Plug>SidewaysRight

" vimwiki doesn't work nicely with vim vinegar `-` shortcut, so this fixes it
nmap <Nop> <Plug>VimwikiRemoveHeaderLevel

" External commands
:command! -nargs=+ D execute ':silent !srd '.<q-args> | execute ':redraw!'
:command! -nargs=+ LodashDoc execute ':silent !srd lodash '.<q-args> | execute ':redraw!'
:command! -nargs=+ CljDoc execute ':silent !srd clj '.<q-args> | execute ':redraw!'

:command! -nargs=+ DotNetDoc execute ':silent !srd dotnet '.<q-args> | execute ':redraw!'
:command! -nargs=+ CSharpDoc execute ':silent !srd csharp '.<q-args> | execute ':redraw!'

:command! VSCode execute ':silent !code -g %' . ":" . line(".") . ":" . virtcol(".") | execute ':redraw!'
:command! WebStorm execute ':silent !webstorm' . " --line " . line(". ") . " --column " . virtcol("."). ' %' | execute ':redraw!'
nmap <leader>gov  :VSCode<cr>
nmap <leader>gow  :WebStorm<cr>

if !exists("g:netrw_banner")
  let g:netrw_banner = 1
endif


if executable('uctags')
  let g:gutentags_ctags_executable = 'uctags'
end
let g:gutentags_file_list_command = 'rg --files'

nnoremap <leader>F :Grepper -tool rg<CR>

