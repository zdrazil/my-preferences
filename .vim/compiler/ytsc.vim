if exists("current_compiler")
  finish
endif
let current_compiler = "ytsc"

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=yarn\ tsc\ 
CompilerSet errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m

let &cpo = s:cpo_save
unlet s:cpo_save
