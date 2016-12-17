# Source config files that are the same for zsh and bash
if [ -f $HOME/.profilerc ]; then
    . $HOME/.profilerc
fi

# use bash completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
  . /opt/local/etc/profile.d/bash_completion.sh
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

export PS1="\u@\h \W> \[$(tput sgr0)\]"

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=1000                   # big big history
export HISTFILESIZE=2000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

shopt -s checkwinsize

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
