# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "/usr/local/bin" ] ; then
    PATH="usr/local/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "/usr/local/lib/python3.7/site-packages" ] ; then
    PATH="/usr/local/lib/python3.7/site-packages:$PATH"
fi

# Node
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
export MANPATH="${MANPATH-$(manpath)}:$NPM_CONFIG_PREFIX/share/man"
export NODE_PATH="$NPM_CONFIG_PREFIX/lib/node_modules:$NODE_PATH"


if [[ "$OSTYPE" == "darwin"* ]]; then
    alias darkMode="2>/dev/null defaults read -g AppleInterfaceStyle"
    export LC_ALL=en_US.UTF-8  
    export LANG=en_US.UTF-8
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Ubuntu make installation of Ubuntu Make binary symlink
    if [ -d "$HOME/.local/share/umake/bin" ]; then
        PATH=~/.local/share/umake/bin:$PATH
    fi
    if [ -e /home/zdrazil/.nix-profile/etc/profile.d/nix.sh ]; then . /home/zdrazil/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
fi

if command -v keychain &> /dev/null; then 
    eval "$(keychain --quiet --eval --agents ssh id_rsa)"
fi

# if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then 
#     # Fix locales
#     export LOCALE_ARCHIVE_2_11="$(nix-build --no-out-link "<nixpkgs>" -A glibcLocales)/lib/locale/locale-archive"
#     export LOCALE_ARCHIVE_2_27="$(nix-build --no-out-link "<nixpkgs>" -A glibcLocales)/lib/locale/locale-archive"
#     export LOCALE_ARCHIVE="/usr/bin/locale"
# fi

export CLICOLOR=1
export EDITOR=vim
export FZF_DEFAULT_COMMAND='rg --files'

alias ddgb='ddgr --np'
