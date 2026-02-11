function fish_prompt
    set -l cwd (string replace $HOME '~' $PWD)
    if test "$cwd" != '~'
        set cwd (basename $cwd)
    end

    set -l suffix '%'
    if test (id -u) -eq 0
        set suffix '#'
    end

    echo -n "$USER@"(prompt_hostname)" $cwd $suffix "
end
