
set homebrew_prefix (brew --prefix)

fish_add_path "$HOME/bin" \
    "$homebrew_prefix/bin" \
    $homebrew_prefix/sbin \
    /usr/local/bin \
    "$HOME/.local/bin" \
    /Applications/MacVim.app/Contents/bin \
    " $HOME/.local/npm-tools/node_modules/.bin"

switch (uname)
    case Darwin
        set -gx LC_ALL en_US.UTF-8
        set -gx LANG en_US.UTF-8
end

set -gx EDITOR vim
