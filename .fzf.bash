# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------

if [[ $- == *i* ]] && [ -f "/opt/homebrew/opt/fzf/shell/completion.bash" ]; then
  source "/opt/homebrew/opt/fzf/shell/completion.bash" 2>/dev/null
fi

if [[ $- == *i* ]] && [ -f "/opt/local/share/fzf/shell/completion.bash" ]; then
  source "/opt/local/share/fzf/shell/completion.bash" 2>/dev/null
fi

# Key bindings
# ------------

if [ -f "/opt/homebrew/opt/fzf/shell/key-bindings.bash" ]; then
  source "/opt/homebrew/opt/fzf/shell/key-bindings.bash"
fi

if [ -f "/opt/local/share/fzf/shell/key-bindings.bash" ]; then
  source "/opt/local/share/fzf/shell/key-bindings.bash"
fi
