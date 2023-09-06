function fish_user_key_bindings
    bind -k f3 append_pipe_fzf
    fzf_key_bindings
    # bind --erase \cr # restore built-in-fish>=3.6.0 Ctrl+R history
end
