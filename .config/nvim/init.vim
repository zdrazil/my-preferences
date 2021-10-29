set guicursor=
set mouse=a
set wildignorecase

set wildmode=list:longest,list:full

" Highlight searches by default
set ignorecase
set smartcase
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

call plug#begin('~/.vim/plugged')

" Themes
Plug 'vim-scripts/CycleColor', { 'on': ['CycleColorNext', 'CycleColorPrev'] }

Plug 'lifepillar/vim-solarized8'
Plug 'chriskempson/base16-vim'
Plug 'pbrisbin/vim-colors-off'
Plug 'romainl/Apprentice'
Plug 'fxn/vim-monochrome'

Plug 'noahfrederick/vim-noctu'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'mhinz/vim-grepper'

Plug 'vimwiki/vimwiki'

Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

Plug 'ojroques/vim-oscyank'

Plug 'iberianpig/tig-explorer.vim'

Plug 'editorconfig/editorconfig-vim'
Plug 'markonm/traces.vim'

Plug 'rstacruz/vim-closer'
Plug 'chiedojohn/vim-case-convert'

Plug 'jpalardy/vim-slime'
Plug 'justinmk/vim-gtfo'

Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/vim-peekaboo'

Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'do': ':TSUpdate'}

" FrontEnd
Plug 'suy/vim-context-commentstring'

" Clojure
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-sexp', { 'for': ['clojure', 'scheme'] }
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'guns/vim-clojure-static'

" C#
Plug 'OmniSharp/omnisharp-vim', { 'for': ['csharp', 'fsharp'] }

Plug 'tweekmonster/startuptime.vim' , { 'on': 'StartupTime' }

call plug#end()

if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit')
  " Enable true color in Vim on tmux (not necessary for NeoVim)
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  " Enable true color in supported terminals
  set termguicolors
endif

" Make mouse work in tmux
if &term =~# '^screen' || &term =~# '^xterm-kitty'
  " tmux knows the extended mouse mode
  set ttymouse=sgr
endif


if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit') || has('gui_running')
  if $USER ==# 'mews'
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

" Leader maps
" nnoremap <leader>o :FZF<cr>
nnoremap <leader><leader> :FZF<cr>
" nnoremap <leader>p :Commands<cr>
nnoremap <leader>; :Commands<cr>
" map <silent>s <Plug>LineLetters


" buffer
" nnoremap <leader>b :Buffers<cr>
nnoremap <leader>bb :Buffers<cr>

" code
nmap <leader>gx :ALEDetail<CR>

nmap <leader>gd <Plug>(coc-definition)
nmap <silent>gd <Plug>(coc-definition)
nmap <leader>grr <Plug>(coc-references)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gy <Plug>(coc-type-definition)

nmap <leader>ga <Plug>(coc-codeaction-selected)
xmap <leader>ga <Plug>(coc-codeaction-selected)
nmap <leader>gA <Plug>(coc-codeaction)
nmap <leader>grn <Plug>(coc-rename)

nnoremap <silent><nowait> <leader>gj  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <leader>gk  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <leader>gl  :<C-u>CocListResume<CR>

nnoremap <leader>gh :call <SID>show_documentation()<CR>

command! -nargs=0 CocFormat :call CocAction('format')

" file
nnoremap <leader>fF :FoldIndent<cr>
nnoremap <leader>fR :Rename<cr>
nnoremap <leader>fve :vsplit $MYVIMRC<cr>
nnoremap <leader>fvs :source $MYVIMRC<cr>
nnoremap <leader>fy :YankPath<cr>

" git
nnoremap <leader>cb :Git blame<cr>
nnoremap <leader>ct :TigBlame<cr>

" open
nmap <leader>ov  :VSCode<cr>
nmap <leader>ow  :WebStorm<cr>
nmap <leader>ot  :TermCurrentFileDir<cr>
nmap <leader>of  :OpenCurrentFileDir<cr>

" project
" change to directory of current file
nnoremap <leader>pc :cd %:p:h<CR>:pwd<CR>

" register
vnoremap <leader>ro :OSCYank<CR>

" search
" nnoremap <leader>f :Rg<cr>
nnoremap <leader>ss :Rg<cr>
nnoremap <leader>. :Rg<cr>
nnoremap <leader>sl :Lines<cr>
nnoremap <leader>sh :History:<cr>
nnoremap <leader>sma :Maps<cr>
nnoremap <leader>smm :Marks<cr>
nnoremap <silent><nowait> <leader>s*  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <leader>scs  :<C-u>CocList snippets<cr>
nnoremap <silent><nowait> <leader>so  :<C-u>CocList outline<cr>
nnoremap <leader>sS :Grepper -tool rg<CR>
nnoremap <leader>> :Grepper -tool rg<CR>

" window

" fzf
imap <c-x><c-l> <plug>(fzf-complete-line)

let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_options = '--cache'
let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_prettier_executable = 'prettier'
let g:ale_javascript_prettier_use_global = 1
highlight ALEError ctermbg=none cterm=underline
highlight ALEWarning ctermbg=none cterm=underline

let g:slime_target = 'tmux'

" Coc.nvim
let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-sql',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-react-refactor',
      \ 'coc-emmet',
      \ 'coc-pyright',
      \ 'coc-snippets',
      \ 'coc-tag',
      \ 'coc-vimlsp',
      \ ]

set updatetime=300

inoremap <silent><expr> <c-space> coc#refresh()
imap <C-@> <C-Space>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction

augroup cocHighlight
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

imap <C-l> <Plug>(coc-snippets-expand)
imap <C-j> <Plug>(coc-snippets-expand-jump)

let g:OmniSharp_highlighting = 0
augroup omnisharp_commands
  autocmd!

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> <Leader>gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>gy <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>gD <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>gi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>gh <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>gcs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ga <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>ga <Plug>(omnisharp_code_actions)
  autocmd FileType cs nmap <silent> <buffer> <Leader>grn <Plug>(omnisharp_rename)
augroup END

augroup omnisharp-autocommands
  autocmd BufWritePre *.cs :OmniSharpCodeFormat
augroup END

let g:vimwiki_list = [{
      \ 'path': '~/vimwiki/',
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

" let g:localvimrc_name = [ ".scilvimrc"]
" let g:localvimrc_persistent = 2

hi Pmenu ctermbg=Black ctermfg=White

let g:ale_fixers = {
      \ 'javascript': ['eslint', 'prettier'],
      \ 'javascriptreact': ['eslint', 'prettier'],
      \ 'typescript': ['eslint', 'prettier'],
      \ 'typescriptreact': ['eslint', 'prettier'],
      \ 'python': ['black'],
      \ 'rust': ['rustfmt'],
      \ 'haskell': ['ormolu'],
      \ 'sh': ['shfmt'],
      \}

let g:ale_linters = {
      \ 'cs': ['OmniSharp'],
      \ 'vimwiki':['writegood'],
      \ 'sh': ['shellcheck'],
      \ 'zsh': ['shellcheck'],
      \ 'bash': ['shellcheck'],
      \ 'haskell': ['hls'],
      \ 'javascript': ['eslint', 'tsserver'],
      \ 'rust': ['rls'],
      \ 'javascriptreact': ['eslint', 'tsserver'],
      \ 'python': ['flake8'],
      \ 'typescript': ['eslint', 'tsserver'],
      \ 'typescriptreact': ['eslint', 'tsserver'],
      \ 'vim': ['vint'],
      \}

" let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

" vimwiki doesn't work nicely with vim vinegar `-` shortcut, so this fixes it
nmap <Nop> <Plug>VimwikiRemoveHeaderLevel

" External commands
:command! -nargs=+ Dash execute ':silent !dash '.<q-args> | execute ':redraw!'
:command! -nargs=+ D execute ':silent !srd '.<q-args> | execute ':redraw!'
:command! -nargs=+ LodashDoc execute ':silent !srd lodash '.<q-args> | execute ':redraw!'
:command! -nargs=+ CljDoc execute ':silent !srd clj '.<q-args> | execute ':redraw!'

:command! -nargs=+ DotNetDoc execute ':silent !srd dotnet '.<q-args> | execute ':redraw!'
:command! -nargs=+ CSharpDoc execute ':silent !srd csharp '.<q-args> | execute ':redraw!'

:command! VSCode execute ':silent !code -g %' . ":" . line(".") . ":" . virtcol(".") | execute ':redraw!'
:command! WebStorm execute ':silent !webstorm' . " --line " . line(". ") . " --column " . virtcol("."). ' %' | execute ':redraw!'

if !exists('g:netrw_banner')
  let g:netrw_banner = 1
endif

if executable('uctags')
  let g:gutentags_ctags_executable = 'uctags'
end
let g:gutentags_file_list_command = 'rg --files'

command FoldIndent setlocal foldmethod=indent
command FoldManual setlocal foldmethod=manual
command FoldSyntax setlocal foldmethod=syntax

command YankPath execute ':let @+ = expand("%")'

augroup dashfiletypes
  au filetype css
        \clojure
        \html
        \haskell
        \javascript,
        \javascriptreact,
        \typescript,
        \typescriptreact,
        \ setl keywordprg=dash
augroup END

call which_key#register('<Space>', 'g:which_key_map')
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

let g:peekaboo_delay=400

let g:which_key_map =  {}
let g:which_key_map.b = { 'name' : '+buffer' }
let g:which_key_map.g = { 'name' : '+code' }
let g:which_key_map.f = { 'name' : '+file' }
let g:which_key_map.c = { 'name' : '+git' }
let g:which_key_map.h = { 'name' : '+help' }
let g:which_key_map.o = { 'name' : '+open' }
let g:which_key_map.s = { 'name' : '+search' }
let g:which_key_map.t = { 'name' : '+toggle' }
let g:which_key_map.w = { 'name' : '+window' }
let g:which_key_map.r = { 'name' : '+register' }

command OpenCurrentFileDir execute ':silent !my-open %:p:h' | execute ':redraw!'
command TermCurrentFileDir execute ':botright vsplit | lcd %:h | terminal ++curwin'

function SlimeOverride_EscapeText_typescript(text)
  return system('babel --presets @babel/preset-typescript -f a.ts', a:text)
endfunction

" let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

set wildcharm=<C-z>
cnoremap <expr> <Tab>   getcmdtype() =~ '[\/?]' ? "<C-g>" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() =~ '[\/?]' ? "<C-t>" : "<S-Tab>"

if exists('$EXTRA_VIM')
  for path in split($EXTRA_VIM, ':')
    exec 'source '.path
  endfor
endif

" Content will be copied to clipboard after register yank operation
" Uses execute because command doesn't have -bar attribute
" https://vi.stackexchange.com/questions/13454/endif-treated-as-part-of-command-in-autocmd
augroup MYOSCYank
  autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
augroup END
let g:oscyank_silent = v:true

lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = "maintained",
  highlight = { enable = true },
  indent = { enable = true },
   incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "v",
      scope_incremental = "grc",
      node_decremental = "<C-h>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>gs>"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>gs<"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  }
}
EOF

" Higlight yank
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=50}
