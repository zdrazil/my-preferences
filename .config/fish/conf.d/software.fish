# asdf

if test -f "$MY_HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish"
    source "$MY_HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish"
end

# direnv

direnv hook fish | source

# iTerm 2

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# Visual Studio Code

string match --quiet "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)
