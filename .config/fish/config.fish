if test -d "$HOME/bin" 
    set PATH $HOME/bin $PATH
end

if test -d "/usr/local/bin" 
    set PATH /usr/local/bin $PATH
end

if test -d "$HOME/.local/bin" 
    set PATH $HOME/.local/bin $PATH
end

if test -d "$HOME/.fzf/bin" 
    set PATH ~/.fzf/bin $PATH 
end


if test -d "$HOME/.local/npm-tools/node_modules/.bin"
    set PATH "$HOME/.local/npm-tools/node_modules/.bin" $PATH
end

switch (uname)
    case Darwin
        export LC_ALL=en_US.UTF-8  
        export LANG=en_US.UTF-8
    case '*'
end


set -gx EDITOR vim

set fish_greeting

#-------------------- ALIASES ------------------------

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

switch (uname)
    case Darwin
        alias mac-showFiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
        alias mac-hideFiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"
    case '*'
end

# FZF
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_DEFAULT_OPTS "--history=$HOME/.fzf-history"


direnv hook fish | source
