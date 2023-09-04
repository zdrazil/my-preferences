source $__fish_data_dir/completions/yarn.fish

complete -c yarn -n '__fish_seen_subcommand_from workspace' -xa '(if test -f package.json; fd package.json -x 'cat' | jq -r ".name" ;end)'
