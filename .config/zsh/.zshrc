# allow shortcut ctrl-W to delete parts of path only
# e.g. a/b/c + ctrl-W -> results in a/b
autoload -U select-word-style
select-word-style bash

if [ -f "$HOME/.config/bash-like/commonrc" ]; then
    . "$HOME/.config/bash-like/commonrc"
fi

if [ -f "$MY_CONFIG_HOME/zsh/zshpath" ]; then
    . "$MY_CONFIG_HOME/zsh/zshpath"
fi

# ------------------ PLUGINS ----------------------
#
source "$MY_DATA_HOME/zgen/zgen.zsh"

# Run `zgen reset` after changing the plugins. You must run this every time you add or remove plugins to trigger the changes.
# if the init script doesn't exist
if ! zgen saved; then

    # specify plugins here
    zgen load zsh-users/zsh-autosuggestions
    zgen load zsh-users/zsh-history-substring-search
    zgen load agkozak/zsh-z

    zgen load zsh-users/zsh-completions src

    # generate the init script from plugins above
    zgen save
fi

# ---------------------------------------------------

# used %{...%} to prevent jumping text when writing
# export PROMPT="·%n@%m %{$fg[reset_color]%}%1~%{$reset_color%}> "
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
export PROMPT="·%(1j.[%j].)%(0?..%?) %1~ > "

# Git in prompt
# autoload -Uz vcs_info
# zstyle ':vcs_info*' formats "%b"
# setopt prompt_subst
# precmd() { vcs_info }

# export RPROMPT='${vcs_info_msg_0_}'

setopt AUTO_MENU # Show completion menu on a successive tab press.

setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.

setopt NO_LIST_BEEP
setopt AUTO_CD

bindkey -e

zstyle ':completion:*' rehash true

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# History
zstyle ':completion:*:history-words' remove-all-dups yes

unsetopt CASE_GLOB

# ------------------ Custom Settings ------------------

# Substring keybindings
if [[ -n "$key_info" ]]; then
    # Emacs
    bindkey -M emacs "$key_info[Control]P" history-substring-search-up
    bindkey -M emacs "$key_info[Control]N" history-substring-search-down

    # Emacs and Vi
    for keymap in 'emacs' 'viins'; do
        bindkey -M "$keymap" "$key_info[Up]" history-substring-search-up
        bindkey -M "$keymap" "$key_info[Down]" history-substring-search-down
    done
fi

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

[ -f "$MY_CONFIG_HOME/fzf/fzf.zsh" ] && source "$MY_CONFIG_HOME/fzf/fzf.zsh"

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--history=$MY_CONFIG_HOME/fzf/fzf-history"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=3"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_USE_ASYNC="true"

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

export ZSHZ_DATA="$MY_CONFIG_HOME/zsh/zshz"

eval "$(direnv hook zsh)"

zgen load zsh-users/zsh-syntax-highlighting
