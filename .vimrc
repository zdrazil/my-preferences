set encoding=utf-8

set mouse=a
set wildignorecase
set hidden

set wildmenu
set wildmode=list:longest,list:full

set hlsearch
set ignorecase
set smartcase
set showmatch

set showcmd
set showmode
set number
set title

set breakindent
let &showbreak = '> '
set linebreak

set incsearch
set cmdheight=2

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

" Themes
" IDE like
" Plug 'vim-scripts/CycleColor', { 'on': ['CycleColorNext', 'CycleColorPrev'] }
" Plug 'lifepillar/vim-solarized8'
" Plug 'chriskempson/base16-vim'
" Plug 'pbrisbin/vim-colors-off'
" Plug 'romainl/Apprentice'
" Plug 'fxn/vim-monochrome'

" Plug 'noahfrederick/vim-noctu'

" Plug 'vimwiki/vimwiki'
"
" Starts slower
" Plug 'sheerun/vim-polyglot'

" Plug 'liuchengxu/vim-which-key'
Plug 'jpalardy/vim-slime'

" Clojure
" Plug 'tpope/vim-fireplace'
" Plug 'guns/vim-sexp', { 'for': ['clojure', 'scheme'] }
" Plug 'tpope/vim-sexp-mappings-for-regular-people'
" Plug 'guns/vim-clojure-static'
" C#
" Plug 'OmniSharp/omnisharp-vim', { 'for': ['csharp', 'fsharp'] }

Plug 'tpope/vim-sensible'
Plug 'jeffkreeftmeijer/vim-dim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'mhinz/vim-grepper'

Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'joaohkfaria/vim-jest-snippets'

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
Plug 'machakann/vim-highlightedyank'
Plug 'AndrewRadev/sideways.vim'

Plug 'justinmk/vim-gtfo'

Plug 'junegunn/vim-peekaboo'

Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'

" FrontEnd
Plug 'suy/vim-context-commentstring'

Plug 'tweekmonster/startuptime.vim' , { 'on': 'StartupTime' }

call plug#end()

runtime plugin/sensible.vim
colorscheme dim

if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

if g:os ==# 'Darwin'
  if system('defaults read -g AppleInterfaceStyle') =~# '^Dark'
    set background=dark   " for the dark version of the theme
  else
    set background=light  " for the light version of the theme
  endif
else
  if $BACKGROUND_THEME ==# 'dark'
    set background=dark
  endif
endif

" Make mouse work in tmux
if &term =~# '^screen' || &term =~# '^xterm-kitty'
  " tmux knows the extended mouse mode
  set ttymouse=sgr
endif

runtime plugin/grepper.vim
let g:grepper.rg.grepprg .= ' -S '
let g:grepper.tools = ['rg', 'grep', 'git' ]
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

let g:mapleader = "\<space>"
inoremap jj <Esc>

" Leader maps
nnoremap <leader><leader> :FZF<cr>
nnoremap <leader>; :Commands<cr>

" buffer
nnoremap <leader>bb :Buffers<cr>

nmap <leader>gx :ALEDetail<CR>

nmap <silent>gd <Plug>(coc-definition)
nmap <leader>grr <Plug>(coc-references)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>ga <Plug>(coc-codeaction-selected)
xmap <leader>ga <Plug>(coc-codeaction-selected)
nmap <leader>gA <Plug>(coc-codeaction)

nmap <leader>grn <Plug>(coc-rename)

nnoremap <silent><nowait> [c  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> ]c  :<C-u>CocNext<CR>

xmap <silent>v <Plug>(coc-range-select)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)

nnoremap <leader>gh :call <SID>show_documentation()<CR>
nnoremap gh :call <SID>show_documentation()<CR>

nmap <leader>gs< <Plug>SidewaysLeft
nmap <leader>gs> <Plug>SidewaysRight

" file
nnoremap <leader>fve :vsplit $MYVIMRC<cr>
nnoremap <leader>fvs :source $MYVIMRC<cr>

" open
nmap <leader>ov  :OpenInVSCode<cr>

" register
vnoremap <leader>ro :OSCYank<CR>

" search
nnoremap <leader>f :Rg<cr>
nnoremap <leader>> :Grepper -tool rg<CR>
nnoremap <leader>. :Rg<cr>
nnoremap <silent><nowait> <leader>scs  :<C-u>CocList snippets<cr>

let g:ale_javascript_eslint_executable = 'eslint_d'
" let g:ale_javascript_eslint_options = '--cache'
let g:ale_javascript_eslint_use_global = 1

let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_disable_lsp = 1

let g:highlightedyank_highlight_duration = 100

" Coc.nvim
let g:coc_global_extensions = [
      \ 'coc-emmet',
      \ 'coc-json',
      \ 'coc-snippets',
      \ 'coc-tabnine',
      \ 'coc-tsserver',
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

imap <C-l> <Plug>(coc-snippets-expand)
imap <C-j> <Plug>(coc-snippets-expand-jump)

let g:ale_fixers = {
      \ 'haskell': ['ormolu'],
      \ 'javascript': ['eslint', 'prettier'],
      \ 'javascriptreact': ['eslint', 'prettier'],
      \ 'python': ['black'],
      \ 'rust': ['rustfmt'],
      \ 'sh': ['shfmt'],
      \ 'typescript': ['eslint', 'prettier'],
      \ 'typescriptreact': ['eslint', 'prettier'],
      \}

let g:ale_linters = {
      \ 'javascript': ['eslint', 'tsserver'],
      \ 'javascriptreact': ['eslint', 'tsserver'],
      \ 'sh': ['shellcheck'],
      \ 'typescript': ['eslint', 'tsserver'],
      \ 'typescriptreact': ['eslint', 'tsserver'],
      \}


:command! VSCode execute ':silent !code -g %' . ":" . line(".") . ":" . virtcol(".") | execute ':redraw!'
:command! OpenInVSCode execute "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
:command! WebStorm execute ':silent !webstorm' . " --line " . line(". ") . " --column " . virtcol("."). ' %' | execute ':redraw!'

let g:netrw_banner = 1

command YankPath execute ':let @+ = expand("%")'

let g:peekaboo_delay=400

if exists('$EXTRA_VIM')
  for path in split($EXTRA_VIM, ':')
    exec 'source '.path
  endfor
endif

augroup MYOSCYank
  autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
augroup END

highlight ALEError ctermbg=none cterm=underline gui=underline
highlight ALEWarning ctermbg=none cterm=underline gui=underline
hi Pmenu ctermbg=Black ctermfg=White
highlight PreProc ctermfg=NONE
highlight Special        ctermfg=NONE
highlight Statement        ctermfg=NONE
highlight Type ctermfg=NONE

" IDE like
" code

" nnoremap <silent><nowait> <leader>gk  :<C-u>CocPrev<CR>
" nnoremap <silent><nowait> <leader>gj  :<C-u>CocNext<CR>
" nnoremap <silent><nowait> <leader>gl  :<C-u>CocListResume<CR>
" command! -nargs=0 CocFormat :call CocAction('format')

" nnoremap <silent><nowait> <leader>gcc  :<C-u>CocList commands<cr>
" nnoremap <silent><nowait> <leader>gco  :<C-u>CocList outline<cr>
" nnoremap <silent><nowait> <leader>gcs  :<C-u>CocList -I symbols<cr>
" nnoremap <silent><nowait> <leader>gcl  :<C-u>CocListResume<CR>
" nmap <leader>gi <Plug>(coc-implementation)

" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" file
" nnoremap <leader>fF :FoldIndent<cr>
" nnoremap <leader>fR :Rename<cr>
" nnoremap <leader>fy :YankPath<cr>

" git
" nnoremap <leader>cb :Git blame<cr>
" nnoremap <leader>ct :TigBlame<cr>

" project
" change to directory of current file
" nnoremap <leader>pc :cd %:p:h<CR>:pwd<CR>

" search
" nnoremap <leader>f :Rg<cr>
" nnoremap <leader>ss :Rg<cr>
" nnoremap <leader>sl :Lines<cr>
" nnoremap <leader>sh :History:<cr>
" nnoremap <leader>sma :Maps<cr>
" nnoremap <leader>smm :Marks<cr>
" nnoremap <silent><nowait> <leader>s*  :<C-u>CocList -I symbols<cr>
" nnoremap <silent><nowait> <leader>so  :<C-u>CocList outline<cr>
" nnoremap <leader>sS :Grepper -tool rg<CR>

" open
" nmap <leader>ow  :WebStorm<cr>
" nmap <leader>ot  :TermCurrentFileDir<cr>
" nmap <leader>of  :OpenCurrentFileDir<cr>

let g:slime_target = 'tmux'
function SlimeOverride_EscapeText_javascript(text)
  return system('js-require', a:text)
endfunction

" let g:OmniSharp_highlighting = 0
" augroup omnisharp_commands
"   autocmd!

"   " The following commands are contextual, based on the cursor position.
"   autocmd FileType cs nmap <silent> <buffer> <Leader>gd <Plug>(omnisharp_go_to_definition)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>gy <Plug>(omnisharp_type_lookup)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>gD <Plug>(omnisharp_find_usages)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>gi <Plug>(omnisharp_find_implementations)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>gh <Plug>(omnisharp_documentation)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>gcs <Plug>(omnisharp_find_symbol)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>ga <Plug>(omnisharp_code_actions)
"   autocmd FileType cs xmap <silent> <buffer> <Leader>ga <Plug>(omnisharp_code_actions)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>grn <Plug>(omnisharp_rename)
" augroup END

" augroup omnisharp-autocommands
"   autocmd BufWritePre *.cs :OmniSharpCodeFormat
" augroup END

" let g:vimwiki_list = [{
"       \ 'path': '~/Dropbox/wiki/',
"       \ 'syntax': 'markdown', 
"       \ 'ext': '.md',
"       \ 'links_space_char': '-',
"       \}]

" let g:vim_markdown_conceal = 0
" let g:vim_markdown_conceal_code_blocks = 0
" let g:vimwiki_conceallevel = 0
" let g:vimwiki_auto_header = 1
" let g:vimwiki_markdown_link_ext = 1
" let g:vimwiki_global_ext = 0
" vimwiki doesn't work nicely with vim vinegar `-` shortcut, so this fixes it
" nmap <Nop> <Plug>VimwikiRemoveHeaderLevel

" let g:which_key_map =  {}
" let g:which_key_map.b = { 'name' : '+buffer' }
" let g:which_key_map.g = { 'name' : '+code' }
" let g:which_key_map.f = { 'name' : '+file' }
" let g:which_key_map.c = { 'name' : '+git' }
" let g:which_key_map.h = { 'name' : '+help' }
" let g:which_key_map.o = { 'name' : '+open' }
" let g:which_key_map.s = { 'name' : '+search' }
" let g:which_key_map.t = { 'name' : '+toggle' }
" let g:which_key_map.w = { 'name' : '+window' }
" let g:which_key_map.r = { 'name' : '+register' }

" call which_key#register('<Space>', 'g:which_key_map')
" nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" External commands
" :command! -nargs=+ Dash execute ':silent !dash '.<q-args> | execute ':redraw!'
" :command! -nargs=+ D execute ':silent !srd '.<q-args> | execute ':redraw!'
" :command! -nargs=+ LodashDoc execute ':silent !srd lodash '.<q-args> | execute ':redraw!'
" :command! -nargs=+ CljDoc execute ':silent !srd clj '.<q-args> | execute ':redraw!'

" :command! -nargs=+ DotNetDoc execute ':silent !srd dotnet '.<q-args> | execute ':redraw!'
" :command! -nargs=+ CSharpDoc execute ':silent !srd csharp '.<q-args> | execute ':redraw!'

" if executable('uctags')
"   let g:gutentags_ctags_executable = 'uctags'
" end
" let g:gutentags_file_list_command = 'rg --files'

" command FoldIndent setlocal foldmethod=indent
" command FoldManual setlocal foldmethod=manual
" command FoldSyntax setlocal foldmethod=syntax


" Identify highlight groups
" function! SynStack ()
"     for i1 in synstack(line("."), col("."))
"         let i2 = synIDtrans(i1)
"         let n1 = synIDattr(i1, "name")
"         let n2 = synIDattr(i2, "name")
"         echo n1 "->" n2
"     endfor
" endfunction
" map gm :call SynStack()<CR>

" command OpenCurrentFileDir execute ':silent !my-open %:p:h' | execute ':redraw!'
" command TermCurrentFileDir execute ':botright vsplit | lcd %:h | terminal ++curwin'
