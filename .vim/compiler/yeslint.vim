" Vim compiler file
" Compiler:    ESLint for JavaScript
" Maintainer:  Romain Lafourcade <romainlafourcade@gmail.com>
" Last Change: 2020 May 17

if exists("current_compiler")
  finish
endif
let current_compiler = "yeslint"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=yarn\ eslint\ --format\ compact
CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
