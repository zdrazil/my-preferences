if test -d "$HOME/bin" 
    set PATH $HOME/bin $PATH
end

if test -d "/usr/local/bin" 
    set PATH /usr/local/bin $PATH
end

if test -d "/opt/local/bin" 
    set PATH /opt/local/bin /opt/local/sbin $PATH
end

if test -d "$HOME/.local/bin" 
    set PATH $HOME/.local/bin $PATH
end

if test -d "$HOME/.local/homebrew/bin" 
    set PATH $HOME/.local/homebrew/bin $PATH
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

# FZF
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_DEFAULT_OPTS "--history=$HOME/.fzf-history"

set -gx HOMEBREW_NO_ANALYTICS "1"

source ~/.asdf/asdf.fish
asdf exec direnv hook fish | source
# direnv hook fish | source


test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish ; or true

# Fish has a bug on Mac https://github.com/fish-shell/fish-shell/issues/6270
if test (uname) = Darwin
    set -l darwin_version (uname -r | string split .)
    # macOS 15 is Darwin 19
    if test "$darwin_version[1]" = 20 -a "$darwin_version[2]" -le 3
        function __fish_describe_command; end
        exit
    end
end
