if [ -f $HOME/.commonprofile ]; then
    . $HOME/.commonprofile
fi

if [ "$BASH" ]; then
    . ~/.bashrc
fi


