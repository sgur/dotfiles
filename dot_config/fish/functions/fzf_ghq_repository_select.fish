function fzf_ghq_repository_select -d "Reposity selection with fzf/ghq"
    set -l selected_repo (ghq list \
        | $FZF_CMD --reverse --no-multi \
            --prompt="repository> " --query "$argv" \
            --scheme=path \
            --preview-window="right,65%" \
            --preview="git -C (ghq list --exact --full-path {}) log -5 --graph --decorate --abbrev-commit --color=always")
    if test -n "$selected_repo"
        cd (ghq list --full-path --exact $selected_repo)
    end
    commandline --function repaint
end
