" http://jonathan.jsphere.com/post/9380848982/pyflakes-errors-in-your-vim-quickfix-window
if exists('current_compiler')
  finish
endif
let current_compiler = 'flake8'
CompilerSet makeprg=flake8\ %
CompilerSet errorformat=%f:%l:%c:\ %t%n\ %m
