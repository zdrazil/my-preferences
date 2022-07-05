function append_pipe_fzf -d "Append fzf to the current command"
    fish_commandline_append " &| fzf"
end
