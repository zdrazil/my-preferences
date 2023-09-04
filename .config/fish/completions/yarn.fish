source $__fish_data_dir/completions/yarn.fish

function find_workspaces -d "If package.json exists, find all the workspace package"
    if test -f package.json
        fd package.json -x cat | jq -r ".name"
    end
end

function not_has_suggestion
    commandline -pc | string match -r 'yarn workspace\s*$'
end

function not_has_script
    commandline -pc | string match -r 'yarn workspace\s*\S*\s*$'
end

function find_scripts -d "Test if a non-switch argument has been given in the current commandline"
    set -l cmd (commandline -poc)

    # Taken from $__fish_data_dir/completions/yarn.fish, fish version 3.6.1 
    $cmd run 2>/dev/null | sed '$d' | awk '{ print $3}'
end


complete -c yarn -n '__fish_seen_subcommand_from workspace; and not_has_suggestion' -xa '(find_workspaces)'

complete -c yarn -n '__fish_seen_subcommand_from workspace; and not_has_script' -xa '(find_scripts)'
