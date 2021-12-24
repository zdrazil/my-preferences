# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Source config files that are the same for zsh and bash
if [ -f "$HOME"/.commonrc ]; then
    . $HOME/.commonrc
fi

if [ -f "$MY_CONFIG_HOME/bash-like/append_paths" ]; then
    . "$MY_CONFIG_HOME/bash-like/append_paths"
fi

# Use bash completion
if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

. "$HOME"/.asdf/asdf.sh
. "$HOME"/.asdf/completions/asdf.bash

#-------------------- SETTINGS ---------------------

export PS1="\u@\h \W> \[$(tput sgr0)\]"

export HISTSIZE=10000     # big big history
export HISTFILESIZE=10000 # big big history
shopt -s histappend       # append to history, don't overwrite it
shopt -s cmdhist          # Save multi-line commands as one command
# Save multi-line commands to the history with embedded newlines
shopt -s lithist

# Put history command onto command line without executing it
shopt -s histverify

# Update window size after every command
shopt -s checkwinsize

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

[ -f "$MY_CONFIG_HOME/fzf/fzf.bash" ] && source "$MY_CONFIG_HOME/fzf/fzf.bash"

eval "$(direnv hook bash)"

if [ -d "/opt/local/bin" ]; then
    PATH=/opt/local/bin:/opt/local/sbin:$PATH
    MANPATH=/opt/local/share/man:$MANPATH
fi

if [ -d "/opt/homebrew/bin" ]; then
    PATH="/opt/homebrew/bin:$PATH"
fi

if [ -d "$HOME/.local/homebrew/bin" ]; then
    PATH="$HOME/.local/homebrew/bin:$PATH"
fi

if [ -d "/Applications/MacVim.app/Contents/bin" ]; then
    PATH="/Applications/MacVim.app/Contents/bin:$PATH"
fi
