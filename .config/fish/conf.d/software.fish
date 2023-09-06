# asdf
if test -f "$homebrew_prefix/opt/asdf/libexec/asdf.fish"
    source "$homebrew_prefix/opt/asdf/libexec/asdf.fish"
end

if test -f "/opt/local/share/asdf/asdf.fish"
    source "/opt/local/share/asdf/asdf.fish"
end

# direnv
direnv hook fish | source

# FZF
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_CTRL_T_OPTS '--preview "bat --style=numbers --color=always --line-range :500 {}" --bind "?:toggle-preview"'
set -gx FZF_DEFAULT_OPTS "--history=$HOME/.fzf-history --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | pbcopy)"
set -gx FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

if test -f "/opt/local/share/fzf/shell/key-bindings.fish"
    source "/opt/local/share/fzf/shell/key-bindings.fish"
end

# Homebrew
set -gx HOMEBREW_NO_ANALYTICS 1

# iTerm 2
test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# Visual Studio Code
string match -q "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)
