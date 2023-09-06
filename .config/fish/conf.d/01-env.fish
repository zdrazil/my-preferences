function add_homebrew_path
    for i in /usr/local /opt/homebrew "/home/linuxbrew/.linuxbrew"
        if test -d $i
            set --function homebrew_prefix $i
        end
    end

    if set --query homebrew_prefix
        fish_add_path "$homebrew_prefix/bin" \
            $homebrew_prefix/sbin
    end
end


set homebrew_prefix (brew --prefix)

fish_add_path "$HOME/bin" \
    "$homebrew_prefix/bin" \
    $homebrew_prefix/sbin \
    /usr/local/bin \
    "$HOME/.local/bin" \
    /Applications/MacVim.app/Contents/bin \
    " $HOME/.local/npm-tools/node_modules/.bin"

functions --erase add_homebrew_path

switch (uname)
    case Darwin
        set -gx LC_ALL en_US.UTF-8
        set -gx LANG en_US.UTF-8
end

set -gx EDITOR vim
