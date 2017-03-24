" http://jonathan.jsphere.com/post/9380848982/pyflakes-errors-in-your-vim-quickfix-window
if exists('current_compiler')
  finish
endif
let current_compiler = 'pyflakes'
CompilerSet makeprg=pyflakes\ %
CompilerSet errorformat=%f:%l:\ %m
