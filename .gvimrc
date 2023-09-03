set guifont=Menlo\ Regular:h14
set guicursor+=a:blinkon0
set vb t_vb=

if g:os ==# 'Darwin'
  set termguicolors
  if system('defaults read -g AppleInterfaceStyle') =~# '^Dark'
    if $USER ==# 'mews'
      colorscheme solarized8
    else
      colorscheme base16-oceanicnext
    endif
    set background=dark   " for the dark version of the theme
  else
    set background=light  " for the light version of the theme
  endif
else
  if $BACKGROUND_THEME ==# 'dark'
    set background=dark
  endif
endif
