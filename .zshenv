# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "/usr/local/bin" ]; then
    PATH="usr/local/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

MY_NPM_GLOBAL="$HOME/.local/npm-tools/node_modules/.bin"
if [ -d "$MY_NPM_GLOBAL" ]; then
    PATH="$MY_NPM_GLOBAL:$PATH"
fi

if [[ $OSTYPE == "darwin"* ]]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

export CLICOLOR=1
export EDITOR=vim
export FZF_DEFAULT_COMMAND='rg --files'
