" python3 -m venv ~/.config/venvs/nvim-venv && source ~/.config/venvs/nvim-venv/bin/activate && python3 -m pip install pynvim && which python

let g:python3_host_prog="~/.config/venvs/nvim-venv/bin/python"
let g:python_host_prog="~/.config/venvs/nvim-venv/bin/python"

set clipboard+=unnamedplus

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
Plug 'lifepillar/vim-solarized8'
Plug 'chriskempson/base16-vim'
Plug 'noahfrederick/vim-noctu'
Plug 'jeffkreeftmeijer/vim-dim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'

Plug 'mhinz/vim-grepper'

Plug 'w0rp/ale'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'"
Plug 'honza/vim-snippets'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

Plug 'iberianpig/tig-explorer.vim'

Plug 'editorconfig/editorconfig-vim'
Plug 'markonm/traces.vim'

Plug 'rstacruz/vim-closer'
Plug 'chiedojohn/vim-case-convert'

Plug 'justinmk/vim-gtfo'

Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/vim-peekaboo'

Plug 'justinmk/vim-sneak'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'do': ':TSUpdate'}

" FrontEnd
Plug 'suy/vim-context-commentstring'

Plug 'tweekmonster/startuptime.vim' , { 'on': 'StartupTime' }

call plug#end()

" Dim and noctu colorscheme can't use following settings, they'd get broken.
" They're only needed for 24bit themes
" if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit')
"   " Enable true color in supported terminals
"   " When 16bit colors scheme is used, we don't want to set this
"   set termguicolors
"   if $BACKGROUND_THEME ==# 'dark'
"     if $USER ==# 'mews'
"       colorscheme solarized8
"     else
"       colorscheme base16-oceanicnext
"     endif
"     set background=dark
"   else
"     set background=light
"   endif
" else
"   colorscheme dim
"   if $BACKGROUND_THEME ==# 'dark'
"     set background=dark
"   else
"     set background=light
"   endif
" endif

colorscheme dim
if $BACKGROUND_THEME ==# 'dark'
  set background=dark
else
  set background=light
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
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>bb :Buffers<cr>

" code
nmap <leader>gx :ALEDetail<CR>

nmap <leader>gd <Plug>(coc-definition)
nmap <silent>gd <Plug>(coc-definition)
nmap <A-LeftMouse> <Plug>(coc-definition)
nmap <leader>grr <Plug>(coc-references)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gy <Plug>(coc-type-definition)

nmap <leader>ga <Plug>(coc-codeaction-selected)
xmap <leader>ga <Plug>(coc-codeaction-selected)
nmap <leader>gA <Plug>(coc-codeaction)
nmap <leader>grn <Plug>(coc-rename)
nmap <F2> <Plug>(coc-rename)

nnoremap <silent><nowait> <leader>gk  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <leader>gj  :<C-u>CocNext<CR>
nnoremap <silent><nowait> [c  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> ]c  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <leader>gl  :<C-u>CocListResume<CR>

nnoremap gh :call <SID>show_documentation()<CR>

command! -nargs=0 CocFormat :call CocAction('format')

nnoremap <silent><nowait> <leader>gcc  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <leader>gco  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <leader>gcs  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <leader>gcl  :<C-u>CocListResume<CR>

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

" search
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
imap <c-x><c-f> <plug>(fzf-complete-path)

let g:ale_virtualtext_cursor = 'disabled'
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
" let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_options = '--cache'
" let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_prettier_executable = 'prettier'
let g:ale_javascript_prettier_use_global = 1
let g:ale_disable_lsp = 1
highlight ALEError ctermbg=none cterm=underline gui=underline
highlight ALEWarning ctermbg=none cterm=underline gui=underline

" Coc.nvim
let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-emmet',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-pyright',
      \ 'coc-react-refactor',
      \ 'coc-snippets',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ ]

set updatetime=300

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <C-x><C-o> coc#refresh()
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

" External commands
:command! VSCode execute ':silent !code -g %' . ":" . line(".") . ":" . virtcol(".") | execute ':redraw!'
:command! WebStorm execute ':silent !webstorm' . " --line " . line(". ") . " --column " . virtcol("."). ' %' | execute ':redraw!'

if !exists('g:netrw_banner')
  let g:netrw_banner = 1
endif

command YankPath execute ':let @+ = expand("%")'

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
  ensure_installed = "all",
  auto_install = true,
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

highlight PreProc ctermfg=NONE
highlight Special        ctermfg=NONE
highlight Statement        ctermfg=NONE
highlight Type ctermfg=NONE

map <C-S> :w<CR>
imap <C-S> <Esc>:w<CR>
vmap <C-S> <Esc>:w<CR>

lua <<EOF
require'lspconfig'.tsserver.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF
