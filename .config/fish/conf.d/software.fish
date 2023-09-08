# asdf

if test -f "$MY_HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish"
    source "$MY_HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish"
end

# direnv

direnv hook fish | source

# iTerm 2

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# Visual Studio Code

if string match --quiet "$TERM_PROGRAM" vscode
    switch uname
        case Darwin
            . '/Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/browser/media/fish_xdg_data/fish/vendor_conf.d/shellIntegration.fish'
        case '*'
            # This is slow
            . (code --locate-shell-integration-path fish)
    end

end
