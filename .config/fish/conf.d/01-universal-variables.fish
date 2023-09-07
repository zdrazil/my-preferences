# Taken from https://github.com/fish-shell/fish-shell/issues/7432#issue-731219402
set -l fish_config_mtime (stat -f %m $__fish_config_dir/conf.d/universal-variables.fish)
if test "$fish_config_changed" = "$fish_config_mtime"
    exit
else
    set -U fish_config_changed $fish_config_mtime
end

# ---- Environment ----

begin
    function add_homebrew_path
        for i in /usr/local /opt/homebrew "/home/linuxbrew/.linuxbrew"
            if test -d $i
                set --function homebrew_prefix $i
            end
        end

        if set --query homebrew_prefix
            fish_add_path "$homebrew_prefix/bin" $homebrew_prefix/sbin
        end
    end

    fish_add_path "$HOME/bin" \
        /usr/local/bin \
        "$HOME/.local/bin" \
        /Applications/MacVim.app/Contents/bin \
        " $HOME/.local/npm-tools/node_modules/.bin"

    add_homebrew_path

    functions --erase add_homebrew_path

    switch (uname)
        case Darwin
            set -U LC_ALL en_US.UTF-8
            set -U LANG en_US.UTF-8
    end

    if test -x mvim
        set -U EDITOR mvim
    else
        set -U EDITOR vim
    end
end

# ---- Software ----

begin
    ## FZF
    set -U FZF_DEFAULT_COMMAND 'rg --files --hidden --follow'
    set -U FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -U FZF_CTRL_T_OPTS '--preview "bat --style=numbers --color=always --line-range :500 {}" --bind "?:toggle-preview"'
    set -U FZF_DEFAULT_OPTS "--history=$HOME/.fzf-history --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | pbcopy)"
    set -U FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

    ## Homebrew
    set -U HOMEBREW_NO_ANALYTICS 1
    set -U HOMEBREW_AUTO_UPDATE_SECS 604800 # 7 days
end

# ---- Theming ----

switch (hostname)
    case Vladimirs-Mews-MacBook-Pro.local
        set -U MY_THEME solarized-dark
    case VladimisMewsMBP
        set -U MY_THEME solarized-dark
    case '*'
        set -U MY_THEME oceanic-next
end

set -U MY_LIGHT_THEME cupertino
set -U BAT_THEME ansi
