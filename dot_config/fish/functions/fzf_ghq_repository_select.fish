function fzf_ghq_repository_select -d "Reposity selection with fzf/ghq"
    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    set -l selected_repo (ghq list \
        | $FZF_CMD --height $FZF_TMUX_HEIGHT \
            --scheme=path \
            --bind=ctrl-z:ignore \
            --no-multi \
            --prompt="repository> " --query "$argv" \
            --preview-window="right,60%" \
            --preview="git -C (ghq list --exact --full-path {}) log -5 --graph --decorate --abbrev-commit --color=always")
    if test -n "$selected_repo"
        cd (ghq list --full-path --exact $selected_repo)
    end
    commandline --function repaint
end
