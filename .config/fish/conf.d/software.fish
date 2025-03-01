# asdf

if test -f "/opt/local/share/asdf/asdf.fish"
    source "/opt/local/share/asdf/asdf.fish"
else if test -f "$MY_HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish"
    source "$MY_HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish"
else if test -f "/opt/pkg/share/asdf/asdf.fish"
    source "/opt/pkg/share/asdf/asdf.fish"
end

# direnv

direnv hook fish | source

# iTerm 2

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish
