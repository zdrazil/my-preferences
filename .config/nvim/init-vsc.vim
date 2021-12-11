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

call plug#begin(stdpath('data') . '/plugged')

" Themes
Plug 'vimwiki/vimwiki'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

Plug 'markonm/traces.vim'
" Plug 'justinmk/vim-gtfo'

Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'

call plug#end()

let g:mapleader = "\<space>"

let g:vimwiki_list = [{
      \ 'path': '~/Dropbox/wiki/',
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

" Higlight yank
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=50}

" function! VSCodeNotifyVisual(cmd, leaveSelection, ...)
"     let mode = mode()
"     if mode ==# 'V'
"         let startLine = line('v')
"         let endLine = line('.')
"         call VSCodeNotifyRange(a:cmd, startLine, endLine, a:leaveSelection, a:000)
"     elseif mode ==# 'v' || mode ==# "\<C-v>"
"         let startPos = getpos('v')
"         let endPos = getpos('.')
"         call VSCodeNotifyRangePos(a:cmd, startPos[1], endPos[1], startPos[2], endPos[2] + 1, a:leaveSelection, a:000)
"     else
"         call VSCodeNotify(a:cmd, a:000)
"     endif
" endfunction

nnoremap <leader><leader> <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>; <Cmd>call VSCodeNotify('workbench.action.showCommands')<CR>

" buffer
nnoremap <leader>bb <Cmd>call VSCodeNotify('workbench.action.openPreviousEditorFromHistory')<CR>
nnoremap <leader>]b <Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>
nnoremap <leader>[b <Cmd>call VSCodeNotify('workbench.action.quickOpenNavigatePreviousInEditorPicker')<CR>

" code
nnoremap <leader>gx <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
nnoremap <leader>gh <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
nnoremap <leader>gd <Cmd>call VSCodeNotify('editor.action.goToDeclaration')<CR>
nnoremap gd <Cmd>call VSCodeNotify('editor.action.goToDeclaration')<CR>
nnoremap <leader>grr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
nnoremap <leader>grR <Cmd>call VSCodeNotify('references-view.findReferences')<CR>

nnoremap <leader>gi <Cmd>call VSCodeNotcify('editor.action.goToImplementation')<CR>
nnoremap <leader>gy <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>

xnoremap <leader>ga <Cmd>call VSCodeNotifyVisual('editor.action.quickFix', 1)<CR>
nnoremap <leader>ga <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>
nnoremap <leader>gA <Cmd>call VSCodeNotify('editor.action.sourceAction')<CR>
nnoremap <leader>grn <Cmd>call VSCodeNotify('editor.action.rename')<CR>
nnoremap ]c <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
nnoremap [c <Cmd>call VSCodeNotify('editor.action.marker.previousInFiles')<CR>

nnoremap <leader>gco <Cmd>call VSCodeNotify('outline.focus')<CR>
nnoremap <leader>gcs <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
nnoremap <leader>gcl <Cmd>call VSCodeNotify('editor.action.marker.previousInFiles')<CR>

nnoremap <leader>gjr <Cmd>call VSCodeNotify('extension.runJest')<CR>
nnoremap <leader>gjd <Cmd>call VSCodeNotify('extension.debugJest')<CR>

nnoremap <leader>fve <Cmd>call VSCodeNotify('command-runner.run', {"command": "nvim-config"})<CR>
nnoremap <leader>fvs :source $MYVIMRC<CR>
nnoremap <leader>fy <Cmd>call VSCodeNotify('copyRelativeFilePath')<CR>

nnoremap <leader>gs< <Cmd>call VSCodeNotify('shiftArgumentLeft')<CR>
nnoremap <leader>gs> <Cmd>call VSCodeNotify('shiftArgumentRight')<CR>

" git
nnoremap <leader>ct <Cmd>call VSCodeNotify('command-runner.run', {"command": "tig blame"})<CR>
workbench.action.createTerminalEditor
" open
nnoremap <leader>oT <Cmd>call VSCodeNotify('workbench.action.createTerminalEditor')<CR>
nnoremap <leader>o <Cmd>call VSCodeNotify('command-runner.run', {"command": "cd fwd"})<CR>
nnoremap <leader>of <Cmd>call VSCodeNotify('revealFileInOS')<CR>

" register
nnoremap <leader>ro <Cmd>call VSCodeNotify('editor.action.clipboardCopyAction')<CR>

" search
nnoremap <leader>. <Cmd>call VSCodeNotify('command-runner.run', {"command": "rgf"})<CR>
nnoremap <leader>scs <Cmd>call VSCodeNotify('editor.action.insertSnippet')<CR>
nnoremap <leader>ss <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
nnoremap <leader>so <Cmd>call VSCodeNotify('outline.focus')<CR>

nnoremap <leader>> <Cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
nnoremap <c-x><c-f> <Cmd>call VSCodeNotify('extension.relativePath')<CR>
nnoremap K <Cmd>call VSCodeNotify('extension.dash.specific')<CR>


nnoremap - <Cmd>call VSCodeNotify('workbench.files.action.focusFilesExplorer')<CR>
nnoremap [q <Cmd>call VSCodeNotify('search.action.focusPreviousSearchResult')<CR>
nnoremap ]q <Cmd>call VSCodeNotify('search.action.focusNextSearchResult')<CR>
xnoremap v <Cmd>call VSCodeNotify('editor.action.smartSelect.expand')<CR>

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine