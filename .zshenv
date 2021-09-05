
for myPath (
    "$HOME/bin"
    "/usr/local/bin"
    "$HOME/.local/bin"
    "$HOME/.local/homebrew/bin"
    "/Applications/MacVim.app/Contents/bin"
    "$HOME/.fzf/bin"
    "$HOME/.local/npm-tools/node_modules/.bin"
    ) 
    {
        if [ -d $myPath ]; then
            PATH="$myPath:$PATH"
        fi
    }

if [ -d "/opt/local/bin" ]; then
    PATH=/opt/local/bin:/opt/local/sbin:$PATH
    MANPATH=/opt/local/share/man:$MANPATH
fi

if [[ $OSTYPE == "darwin"* ]]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

export CLICOLOR=1
export EDITOR=vim
export FZF_DEFAULT_COMMAND='rg --files'

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

if [ -e '$HOME/.nix-profile/etc/profile.d/nix.sh' ]; then
  . '$HOME/.nix-profile/etc/profile.d/nix.sh'
fi

