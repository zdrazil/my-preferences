for myPath (
    "$HOME/bin"
    "/usr/local/bin"
    "$HOME/.local/bin"
    "$HOME/.local/homebrew/bin"
    "/Applications/MacVim.app/Contents/bin"
    "$HOME/.fzf/bin"
    "$HOME/.local/npm-tools/node_modules/.bin"
    "/opt/local/bin"
    "/opt/local/sbin"
    ) 
    {
        if [ -d $myPath ]; then
            PATH="$myPath:$PATH"
        fi
    }

if [ -d "/opt/local/bin" ]; then
    MANPATH=/opt/local/share/man:$MANPATH
fi

