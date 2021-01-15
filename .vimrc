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
" Plug 'purescript-contrib/purescript-vim'

Plug 'w0rp/ale'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'natebosch/vim-lsc'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'xabikos/vscode-javascript'
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
Plug 'tommcdo/vim-exchange'
Plug 'AndrewRadev/sideways.vim'

Plug 'jpalardy/vim-slime'

" Plug 'rhysd/devdocs.vim'
Plug 'justinmk/vim-gtfo'

Plug 'justinmk/vim-sneak'
" Plug 'easymotion/vim-easymotion'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'liuchengxu/vista.vim'

" FrontEnd
Plug 'suy/vim-context-commentstring'

" Plug 'mattn/emmet-vim'

" Clojure
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'guns/vim-clojure-static'
" Plug 'tpope/vim-salve'
" Plug 'venantius/vim-cljfmt'

Plug 'tweekmonster/startuptime.vim'
" Plug 'takac/vim-hardtime'
" Plug 'danth/pathfinder.vim'
" Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

call plug#end()

runtime plugin/sensible.vim

" dark mode enabled?
if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
  colorscheme solarized8
  set background=dark
elseif has("gui_macvim")
  colorscheme gruvbox-high
  colorscheme base16-gruvbox-light-medium
  " colorscheme nofrils-acme
  " colorscheme monotone
  set background=light
else 
  colorscheme solarized8
  set background=dark
endif

" colors dim

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
nnoremap <leader>h :History:<cr>
" nnoremap <leader>ss :Snippets<cr>

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
set foldmethod=indent
set foldlevel=99

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

" Coc.nvim
" let g:coc_global_extensions = [
"       \ 'coc-css',
"       \ 'coc-perl',
"       \ 'coc-sql',
"       \ 'coc-fsharp',
"       \ 'coc-html',
"       \ 'coc-json',
"       \ 'coc-tsserver',
"       \ 'coc-emmet',
"       \ 'coc-pyright',
"       \ 'coc-snippets',
"       \ 'coc-omnisharp',
"       \ ]

" set updatetime=300
" inoremap <silent><expr> <c-space>a coc#refresh()

" nmap <leader>d <Plug>(coc-definition)
" nmap <leader>gd <Plug>(coc-definition)
" nmap <leader>gy <Plug>(coc-type-definition)

" nmap <leader>gi <Plug>(coc-implementation)
" nmap <leader>gr <Plug>(coc-references)

" nmap <leader>[c <Plug>(coc-diagnostic-prev)
" nmap <leader>]c <Plug>(coc-diagnostic-next)

" nmap <leader>gca <Plug>(coc-codeaction-selected)
" xmap <leader>gca <Plug>(coc-codeaction-selected)
" nmap <leader>gcaa <Plug>(coc-codeaction)

" nmap <leader>grn <Plug>(coc-rename)

" nnoremap <silent><nowait> <leader>gcs  :<C-u>CocList -I symbols<cr>

" nnoremap <silent><nowait> <leader>ss  :<C-u>CocList snippets<cr>

" " nnoremap <silent><nowait> <leader>gco  :<C-u>CocList outline<cr>
" nnoremap <silent><nowait> <leader>gco :<C-u>Vista finder<cr>

" command! -nargs=0 CocFormat :call CocAction('format')

" inoremap <silent><expr> <c-space> coc#refresh()
" imap <C-@> <C-Space>

" nnoremap <leader>gh :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction



" autocmd CursorHold * silent call CocActionAsync('highlight')
let g:lsc_auto_map = {
    \ 'GoToDefinition': ['<leader>d', '<leader>gd'],
    \ 'GoToDefinitionSplit': ['<C-W>]', '<C-W><C-]>'],
    \ 'FindReferences': '<leader>gr',
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
  \ 'vim' : {
    \   'name': 'vim-language-server',
    \   'command': 'vim-language-server --stdio',
    \      'message_hooks': {
    \          'initialize': {
    \              'initializationOptions': { 'vimruntime': $VIMRUNTIME, 'runtimepath': &rtp },
    \          },
    \      },
    \   },
	\ 'sh': 'bash-language-server start',
  \ }

nnoremap <Leader>F :Grepper -tool rg<CR>
nmap <Leader>gs  <plug>(GrepperOperator)
xmap <Leader>gs  <plug>(GrepperOperator)

" nmap <Leader>gk <Plug>(devdocs-under-cursor)

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
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_global_ext = 0

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
      \ 'javascriptreact': ['eslint'],
      \ 'typescript': ['eslint'],
      \ 'typescriptreact': ['eslint'],
      \ 'purescript': ['purty'],
      \ 'python': ['black'],
      \ 'cs': ['uncrustify'],
      \}

let g:ale_linters = {
      \ 'markdown':['writegood'],
      \ 'vimwiki':['writegood'],
      \ 'haskell': ['hlint'],
      \ 'sh': ['shellcheck'],
      \ 'zsh': ['shellcheck'],
      \ 'bash': ['shellcheck'],
      \ 'javascript': ['eslint', 'tsserver'],
      \ 'javascriptreact': ['eslint', 'tsserver'],
      \ 'typescript': ['eslint', 'tsserver'],
      \ 'typescriptreact': ['eslint', 'tsserver'],
      \ 'purescript': ['purescript-language-server'],
      \}

let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
" let g:EasyMotion_do_mapping = 0 " Disable default mappings
" " nmap s <Plug>(easymotion-bd-w)
" nmap s <Plug>(easymotion-overwin-f2)

" " Turn on case-insensitive feature
" let g:EasyMotion_smartcase = 1
" let g:EasyMotion_use_upper = 1
" let g:EasyMotion_keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;'

" " JK motions: Line motions
" map <Leader>j <Plug>(easymotion-j)
" map <Leader>k <Plug>(easymotion-k)



" let g:vista_default_executive = 'coc'

nmap <leader>gs< <Plug>SidewaysLeft
nmap <leader>gs> <Plug>SidewaysRight

autocmd FileType purescript setlocal commentstring=--%s
autocmd FileType purescript setlocal comments=:--

" vimwiki doesn't work nicely with vim vinegar `-` shortcut, so this fixes it
nmap <Nop> <Plug>VimwikiRemoveHeaderLevel

if has("autocmd")
  au BufReadPost *.rkt,*.rktl set filetype=scheme.racket
endif

autocmd FileType javascript set keywordprg=srd\ dd
autocmd FileType javascriptreact set keywordprg=srd\ dd
autocmd FileType typescript set keywordprg=srd\ dd
autocmd FileType typescriptreact set keywordprg=srd\ dd

:command! VSCode execute ':silent !code -g %' . ":" . line(".") . ":" . virtcol(".") | execute ':redraw!'
nmap <leader>gov  :VSCode<cr>

:command! -nargs=+ D execute ':silent !srd '.<q-args> | execute ':redraw!'
:command! -nargs=+ LodashDoc execute ':silent !srd lodash '.<q-args> | execute ':redraw!'
:command! -nargs=+ CljDoc execute ':silent !srd clj '.<q-args> | execute ':redraw!'

:command! -nargs=+ DotNetDoc execute ':silent !srd dotnet '.<q-args> | execute ':redraw!'
:command! -nargs=+ CSharpDoc execute ':silent !srd csharp '.<q-args> | execute ':redraw!'

" toogle line numbers
" set number relativenumber

" augroup numbertoggle
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
" augroup END
"
let g:hardtime_default_on = 1
let g:list_of_normal_keys = ["h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_visual_keys = ["h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]


let g:hardtime_ignore_quickfix = 1

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

if !exists("g:netrw_banner")
  let g:netrw_banner = 1
endif

let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascript = ['javascript']
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescript = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['javascript']

imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
