# Source config files that are not to be public (API tokens etc.) 
if [ -r ~/.not-public ]
then
    source ~/.not-public
fi

if  [ -f /usr/local/etc/profile.d/autojump.sh ]; then
    . /usr/local/etc/profile.d/autojump.sh
fi

# Use bash completion
if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
fi

#-------------------- SETTINGS ---------------------

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

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

# Update window size after every command
shopt -s checkwinsize

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


#-------------------- ALIASES ------------------------
# Shortcuts for ls.
alias lsl='ls -l'
alias lsa='ls -a'

# Compatibility with other Unix systems
ls --color=auto &> /dev/null && alias ls='ls --color=auto' ||

# Mac Specific Aliases
if [[ $OSTYPE == darwin* ]]; then
    alias suz='su -l zdraz'
    alias mac-showFiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
    alias mac-hideFiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

    alias vnchorus='wakeonlan d8:cb:8a:e4:01:dd && sleep 2 && open vnc://horus-desktop.local:36154'
    alias vncmacmini='open vnc://Mac-mini.local'
    alias vncamun='open vnc://amun-laptop.local'
    alias vncra='open vnc://ra-desktop.local'
    alias vnclocal='open vnc://localhost:5901'

    alias wolwindows='wakeonlan d8:cb:8a:e4:01:dd'

    alias subl='open -a "Sublime Text"'
    alias vcode='open -a "Visual Studio Code"'
    alias chrome='open -a "Google Chrome"'
    alias firefox='open -a "Firefox"'
    alias safari='open -a "Safari"'
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function npm-do { (PATH=$(npm bin):$PATH; eval $@;) }
