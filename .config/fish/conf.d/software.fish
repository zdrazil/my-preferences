set homebrew_prefix

if command --search brew &>/dev/null
    set homebrew_prefix (brew --prefix)
end

# asdf

if test -f "$homebrew_prefix/opt/asdf/libexec/asdf.fish"
    source "$homebrew_prefix/opt/asdf/libexec/asdf.fish"
end

set --erase homebrew_prefix

# direnv

direnv hook fish | source

# iTerm 2

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# Visual Studio Code

string match --quiet "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)
