# https://zenn.dev/yamo/articles/5c90852c9c64ab
# fzf を使って git のブランチを選択して git switch する fish 関数
function fzf_git_branch_select -d "Branch selection with fzf"
    git branch --all --format='%(refname:short)' \
        | $FZF_CMD --exit-0 --reverse --no-multi \
            --prompt="branches> " --query "$argv" \
            --preview-window="right,65%" \
            --preview="git log -5 --graph --decorate --abbrev-commit --color=always {}" \
        | head -n 1 \
        | sed 's/\s//g; s/\*//g; s/^origin\///g' \
        | read target_branch
    if test -n "$target_branch"
        git switch $target_branch
    end
    commandline --function repaint
end
