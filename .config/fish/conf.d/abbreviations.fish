abbr --add g git
abbr --add lg lazygit
abbr --add yw 'yarn workspace'

# perl -wnl -e 's/hello/hi/g and print'
abbr --add pgrep 'perl -wnl -e'

# perl -wnl -e 's/hello/ and print'
abbr --add psed 'perl -wpl -e'

# use quotemeta
abbr --add psed-fixed "perl -wpl -e 's/\Qstring\E/replacement/g'"
