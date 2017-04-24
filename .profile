if [ -f $HOME/.commonprofile ]; then
    . $HOME/.commonprofile
fi

if [ "$BASH" ]; then
    . ~/.bashrc
    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
fi


