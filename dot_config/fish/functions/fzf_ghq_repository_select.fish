function fzf_ghq_repository_select -d "Reposity selection with fzf/ghq"
    ghq list | $FZF_CMD --exit-0 --reverse --prompt="repository> " --query "$argv" | read select
    if test -n "$select"
        set -l local (ghq root)
        cd $local/$select
    end
    commandline --function repaint
end
