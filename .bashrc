# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# Source config files that are the same for zsh and bash
if [ -f $HOME/.commonrc ]; then
    . $HOME/.commonrc
fi

# Use bash completion
if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi


# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color | *-256color) color_prompt=yes ;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm* | rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *) ;;

esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

#-------------------- SETTINGS ---------------------

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

export PS1="\u@\h \W> \[$(tput sgr0)\]"

export HISTSIZE=100000     # big big history
export HISTFILESIZE=100000 # big big history
shopt -s histappend        # append to history, don't overwrite it
shopt -s cmdhist           # Save multi-line commands as one command
# Save multi-line commands to the history with embedded newlines
shopt -s lithist

# Put history command onto command line without executing it
shopt -s histverify

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Update window size after every command
shopt -s checkwinsize

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if [ -d "$HOME/.asdf" ] ; then
    . $HOME/.asdf/asdf.sh
    . $HOME/.asdf/completions/asdf.bash
     eval "$(asdf exec direnv hook bash)"
fi


if [ -d "/opt/local/bin" ]; then
    PATH=/opt/local/bin:/opt/local/sbin:$PATH
    MANPATH=/opt/local/share/man:$MANPATH
fi

if [ -d "$HOME/.local/homebrew/bin" ]; then
    PATH="$HOME/.local/homebrew/bin:$PATH"
fi

if [ -d "/Applications/MacVim.app/Contents/bin" ]; then
    PATH="/Applications/MacVim.app/Contents/bin:$PATH"
fi

