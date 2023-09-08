abbr --add g git
abbr --add choose "tr -s ' ' | cut -d ' ' -f"
abbr --add lg lazygit
abbr --add yw 'yarn workspace'

# perl -wnl -e 's/hello/ and print'
abbr --add pgrep 'perl -wnl -e'

# perl -wpl -e 's/hello/hi/g'
abbr --add psed 'perl -wpl -e'

# use quotemeta
abbr --add psed-fixed "perl -wpl -e 's/\Qstring\E/replacement/g'"
