function delete-last-history --description "Deletes and echo the last command from the shell history."
    set last_entry (history | head -n 1 | cut -d" " -f2)
    history delete --exact --case-sensitive -- "$last_entry"
    echo "$last_entry"
end
