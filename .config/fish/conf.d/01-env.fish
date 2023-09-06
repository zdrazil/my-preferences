
fish_add_path "$HOME/bin" \
    /opt/homebrew/bin \
    /opt/homebrew/sbin \
    /usr/local/bin \
    "/home/linuxbrew/.linuxbrew/bin" \
    "$HOME/.local/bin" \
    "$HOME/.emacs.d/bin" \
    "$HOME/.local/homebrew/bin" \
    "/Applications/MacVim.app/Contents/bin" \
    "$HOME/.fzf/bin" \
    "$HOME/.local/npm-tools/node_modules/.bin" \
    /opt/local/bin \
    /opt/local/sbin

switch (uname)
    case Darwin
        set -gx LC_ALL en_US.UTF-8
        set -gx LANG en_US.UTF-8
end

set -gx EDITOR vim
