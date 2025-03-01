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

# Visual Studio Code

if string match --quiet "$TERM_PROGRAM" vscode
    switch uname
        case Darwin
            . 'Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish'
        case '*'
            # This is slow
            . (code --locate-shell-integration-path fish)
    end
end
