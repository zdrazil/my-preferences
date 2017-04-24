# Source config files that are the same for zsh and bash
if [ -f $HOME/.commonrc ]; then
    . $HOME/.commonrc
fi

# Use bash completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
  . /opt/local/etc/profile.d/bash_completion.sh
fi

if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
fi


export PS1="\u@\h \W> \[$(tput sgr0)\]"

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                    # big big history
export HISTFILESIZE=100000              # big big history
shopt -s histappend                      # append to history, don't overwrite it
shopt -s cmdhist                         # Save multi-line commands as one command
# Save multi-line commands to the history with embedded newlines
shopt -s lithist

# Put history command onto command line without executing it
shopt -s histverify


# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a"

# Update window size after every command
shopt -s checkwinsize

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space
