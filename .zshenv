if [[ $OSTYPE == "darwin"* ]]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

export EDITOR=vim

if [ -d "/opt/local/bin" ]; then
    MANPATH=/opt/local/share/man:$MANPATH
fi


# if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
#   . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
# fi

# if [ -e '$HOME/.nix-profile/etc/profile.d/nix.sh' ]; then
#   . '$HOME/.nix-profile/etc/profile.d/nix.sh'
# fi

