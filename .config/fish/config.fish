
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
set -gx FZF_DEFAULT_OPTS "--history=$HOME/.fzf-history"

set -gx HOMEBREW_NO_ANALYTICS 1
set -gx BACKGROUND_THEME dark


# #-------------------- THEMING ------------------------

if test -e "$HOME/.config/fish/not-public.fish"
    source "$HOME/.config/fish/not-public.fish"
end

# save computer specific themes to .not-public
if test -z $MY_THEME
    set -gx MY_THEME oceanic-next
end

if test -z $MY_LIGHT_THEME
    set -gx MY_LIGHT_THEME cupertino
end

switch (uname)
    case Darwin
        set color_theme (defaults read -g AppleInterfaceStyle 2>/dev/null)
        if [ "$color_theme" != Dark ]
            set -gx BACKGROUND_THEME light
        end
    case '*'
end

if command -v theme-sh >/dev/null
    if [ "$BACKGROUND_THEME" = light ]
        theme-sh $MY_LIGHT_THEME
    else
        theme-sh $MY_THEME
    end
end

set -gx BAT_THEME ansi

# # starship init fish | source
source "$homebrew_prefix/opt/asdf/libexec/asdf.fish"

direnv hook fish | source

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish
