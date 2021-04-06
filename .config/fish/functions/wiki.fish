function wiki --description "Change dir and search wiki"
     cd "$HOME/vimwiki"
     vim -c ':copen' -q (rg --vimgrep -S $argv "$HOME/vimwiki" | psub)
end
