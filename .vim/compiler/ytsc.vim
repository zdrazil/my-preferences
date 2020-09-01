if exists("current_compiler")
  finish
endif
let current_compiler = "ytsc"

CompilerSet makeprg=yarn\ tsc\ --noEmit\ 

setlocal errorformat^=%E%f\ %#(%l\\,%c):\ %trror\ TS%n:\ %m,
        \%W%f\ %#(%l\\,%c):\ %tarning\ TS%n:\ %m,
