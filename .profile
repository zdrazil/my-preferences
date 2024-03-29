# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "/usr/local/bin" ]; then
    PATH="usr/local/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "/usr/local/lib/python3.7/site-packages" ]; then
    PATH="/usr/local/lib/python3.7/site-packages:$PATH"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Ubuntu make installation of Ubuntu Make binary symlink
    if [ -d "$HOME/.local/share/umake/bin" ]; then
        PATH=~/.local/share/umake/bin:$PATH
    fi
fi

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

export CLICOLOR=1
export EDITOR=vim

if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi
