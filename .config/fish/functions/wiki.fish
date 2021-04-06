function wiki --description "Change dir and search wiki"
    cd "$HOME/vimwiki"
    if [ (count $argv) -eq 1 ];
        vim -c ':copen' -q (rg --vimgrep -S $argv "$HOME/vimwiki" | psub)
        return
    else
        vim -c ':VimwikiIndex'
        return
    end
end
