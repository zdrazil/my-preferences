
fish_add_path "$HOME/bin" \
    /opt/homebrew/bin \
    /opt/homebrew/sbin \
    /usr/local/bin \
    "/home/linuxbrew/.linuxbrew/bin" \
    "$HOME/.local/bin" \
    "$HOME/.emacs.d/bin" \
    "$HOME/.local/homebrew/bin" \
    "/Applications/MacVim.app/Contents/bin" \
    "$HOME/.fzf/bin" \
    "$HOME/.local/npm-tools/node_modules/.bin" \
    /opt/local/bin \
    /opt/local/sbin

set homebrew_prefix (brew --prefix)

switch (uname)
    case Darwin
        export LC_ALL=en_US.UTF-8
        export LANG=en_US.UTF-8
    case '*'
end

set -gx EDITOR vim
set fish_greeting

# #-------------------- ALIASES ------------------------

# FZF
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_CTRL_T_OPTS '--preview "bat --style=numbers --color=always --line-range :500 {}" --bind "?:toggle-preview"'
set -gx FZF_DEFAULT_OPTS "--history=$HOME/.fzf-history --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | pbcopy)"
set -gx FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

set -gx HOMEBREW_NO_ANALYTICS 1

# #-------------------- THEMING ------------------------

switch (hostname)
    case Vladimirs-Mews-MacBook-Pro.local
        set -gx MY_THEME solarized-dark
    case VladimisMewsMBP
        set -gx MY_THEME solarized-dark
    case '*'
        set -gx MY_THEME oceanic-next
end
set -gx MY_LIGHT_THEME cupertino
set -gx BACKGROUND_THEME (change-theme)
set -gx BAT_THEME ansi

if test -f "$homebrew_prefix/opt/asdf/libexec/asdf.fish"
    source "$homebrew_prefix/opt/asdf/libexec/asdf.fish"
end

if test -f "/opt/local/share/fzf/shell/key-bindings.fish"
    source "/opt/local/share/fzf/shell/key-bindings.fish"
end

if test -f "/opt/local/share/asdf/asdf.fish"
    source "/opt/local/share/asdf/asdf.fish"
end

direnv hook fish | source

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

string match -q "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)

# #------------------------ ABBREVIATIONS --------------------

abbr --a lg 'lazygit'
