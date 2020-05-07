if exists('g:current_compiler')
  finish
endif
let g:current_compiler = 'stylelint'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=yarn\ stylelint\ --custom-formatter\ ~/.vim/compiler/stylelint-formatter-unix\ %
CompilerSet errorformat=%f:%l:%c:%m
