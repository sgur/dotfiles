function fzf_ghq_repository_select -d "Reposity selection with fzf/ghq"
    ghq list \
        | $FZF_CMD --exit-0 --reverse --prompt="repository> " --query "$argv" \
            --scheme=path \
            --preview-window="right,65%" \
            --preview="git -C (ghq list --exact --full-path {}) log -5 --graph --decorate --abbrev-commit --color=always" \
        | read select
    if test -n "$select"
        cd (ghq list --full-path --exact $select)
    end
    commandline --function repaint
end
