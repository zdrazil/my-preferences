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

for myMan (
    "/opt/local/share/man"
    "$HOME/.local/homebrew/share/man"
    ) 
    {
        if [ -d $myMan ]; then
            MANPATH="$myMan:$MANPATH"
        fi
    }
