# Taken from https://github.com/fish-shell/fish-shell/issues/7432#issue-731219402
set -l fish_config_mtime (stat -f %m $__fish_config_dir/conf.d/01-universal-variables.fish)
if test "$fish_config_changed" = "$fish_config_mtime"
    exit
else
    set -U fish_config_changed $fish_config_mtime
end

# ---- Environment ----

begin
    function add_homebrew_path
        for i in /usr/local /opt/homebrew "/home/linuxbrew/.linuxbrew" "$HOME/.local/homebrew" 
            if test -d $i
                # Set homebrew prefix for later use in scripts. 
                # It's faster than `brew --prefix` by  around 10-20 ms.
                # By evaluating it only once, we save time.
                set -U MY_HOMEBREW_PREFIX $i
            end
        end
        echo $MY_HOMEBREW_PREFIX


        if set --query MY_HOMEBREW_PREFIX
            fish_add_path "$MY_HOMEBREW_PREFIX/bin" $MY_HOMEBREW_PREFIX/sbin
        end
    end

    fish_add_path "$HOME/bin" \
        /usr/local/bin \
        "$HOME/.local/bin" \
        /Applications/MacVim.app/Contents/bin \
        " $HOME/.local/npm-tools/node_modules/.bin"

    add_homebrew_path

    functions --erase add_homebrew_path

    if test -x mvim
        set -U EDITOR mvim
    else
        set -U EDITOR vim
    end
end

# ---- Software ----

## FZF
set -U FZF_DEFAULT_COMMAND 'rg --files --hidden --follow'
set -U FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -U FZF_CTRL_T_OPTS '--preview "bat --style=numbers --color=always --line-range :500 {}" --bind "?:toggle-preview"'
set -U FZF_DEFAULT_OPTS "--history=$HOME/.fzf-history --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | pbcopy)"
set -U FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

## Homebrew
set -U HOMEBREW_NO_ANALYTICS 1
set -U HOMEBREW_AUTO_UPDATE_SECS 604800 # 7 days

# ---- Theming ----

set -U BAT_THEME ansi
