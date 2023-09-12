source $__fish_data_dir/completions/yarn.fish

function __my_yarn_find_workspaces -d "If package.json exists, find all the workspace packages"
    if test -f package.json
        fd package.json --exec jq --raw-output ".name" {}
    end
end

function __my_yarn_workspace_has_suggestion
    commandline -pc | string match -r 'yarn workspace\s+\S*$'
end

function __my_yarn_workspace_has_script
    commandline -pc | string match -r 'yarn workspace\s+\S+\s+\S*$'
end

function __my_yarn_workspace_find_scripts -d "Test if a non-switch argument has been given in the current commandline"
    set -l cmd (commandline -poc)

    # Instead of parsing and searching through the files, we could use the following command:
    # $cmd run 2>/dev/null | sed '$d' | awk '{ print $3}'
    # But it's. `yarn workspace [package-name] run` takes approximately 1.5 seconds. 
    # The provided code only takes around 50 milliseconds.

    set -l package_name (echo $cmd | awk '{print $3}')

    set -l package_file (rg --files-with-matches --glob '**/package.json' "\"name\": \"$package_name\"")

    # https://github.com/fish-shell/fish-shell/issues/3552#issuecomment-260564497
    and jq --raw-output '.scripts | to_entries[] | "\(.key)\t\(.value)"' -- $package_file
end

complete -c yarn -n '__fish_seen_subcommand_from workspace; and __my_yarn_workspace_has_suggestion' -xa '(__my_yarn_find_workspaces)'

complete -c yarn -n '__fish_seen_subcommand_from workspace; and __my_yarn_workspace_has_script' -xa '(__my_yarn_workspace_find_scripts)'
