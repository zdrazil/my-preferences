function __append_pipe_fzf -d "Append fzf to the current command"
    set -l cmd less
    if set -q PAGER
        echo $PAGER | read -at cmd
    end

    fish_commandline_append " &| fzf"
end
