# Enable colors
export CLICOLOR=1

export EDITOR=vim

if [[ "$OSTYPE" == "darwin"* ]]; then
    export LC_ALL=en_US.UTF-8  
    export LANG=en_US.UTF-8
fi

if [ "$BASH" ]; then
    . ~/.bashrc
    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi