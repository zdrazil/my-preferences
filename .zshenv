if [[ $OSTYPE == "darwin"* ]]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

export CLICOLOR=1
export EDITOR=vim
export FZF_DEFAULT_COMMAND='rg --files'

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

if [ -e '$HOME/.nix-profile/etc/profile.d/nix.sh' ]; then
  . '$HOME/.nix-profile/etc/profile.d/nix.sh'
fi

