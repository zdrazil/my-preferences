if [ -f $HOME/.commonrc ]; then
    . $HOME/.commonrc
fi

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

fpath=(~/.zsh/completions $fpath)

# ------------------ PLUGINS ----------------------
#
source "${HOME}/.zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then

  # specify plugins here
  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-history-substring-search
  zgen load laggardkernel/zsh-thefuck
  zgen load agkozak/zsh-z
  # zgen load marlonrichert/zsh-autocomplete


  zgen load zsh-users/zsh-completions src

  # generate the init script from plugins above
  zgen save
fi

zstyle ":prezto:module:thefuck" alias "damn"

# ---------------------------------------------------

autoload -Uz colors && colors

# used %{...%} to prevent jumping text when writing
export PROMPT="·%n@%m %{$fg[reset_color]%}%1~%{$reset_color%}> "

# Git in prompt
autoload -Uz vcs_info
zstyle ':vcs_info*' formats "%b"
setopt prompt_subst
precmd() { vcs_info }

export RPROMPT='${vcs_info_msg_0_}'

setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
setopt COMPLETE_ALIASES

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.setopt EXTENDED_HISTORY

# setopt SHARE_HISTORY             # Share history between all sessions.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.

setopt NO_LIST_BEEP
setopt AUTO_PUSHD
setopt AUTO_CD
setopt PUSHD_IGNORE_DUPS

bindkey -e

zstyle ':completion:*' rehash true

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
unsetopt CASE_GLOB

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Directories
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' remove-all-dups yes

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# ------------------ EXTERNAL SOURCE FILES --------

if [ -d $HOME/.zsh/ ]; then
  for file in $HOME/.zsh/*.zsh; do
    source $file
  done
fi


# ------------------ Custom Settings ------------------

# Substring keybindings
if [[ -n "$key_info" ]]; then
  # Emacs
  bindkey -M emacs "$key_info[Control]P" history-substring-search-up
  bindkey -M emacs "$key_info[Control]N" history-substring-search-down

  # Vi
  bindkey -M vicmd "k" history-substring-search-up
  bindkey -M vicmd "j" history-substring-search-down

  # Emacs and Vi
  for keymap in 'emacs' 'viins'; do
    bindkey -M "$keymap" "$key_info[Up]" history-substring-search-up
    bindkey -M "$keymap" "$key_info[Down]" history-substring-search-down
  done
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=3"
export ZSH_AUTOSUGGEST_USE_ASYNC="true"

function cowsay-random {
  cowsay -f "$(cowsay -l | sed '1d' | tr ' ' '\n' | sort -R | head -1)"
}

# fortune -sa | cowsay

# For zsh-autocomplete
# zstyle ':autocomplete:list-choices:*' min-input 3
