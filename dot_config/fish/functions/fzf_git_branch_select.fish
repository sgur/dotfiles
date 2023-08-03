# https://zenn.dev/yamo/articles/5c90852c9c64ab
# fzf を使って git のブランチを選択して git switch する fish 関数
function fzf_git_branch_select -d "Branch selection with fzf"
    set -l selected_branch (git branch --all --format='%(refname:short)' \
        | $FZF_CMD --reverse --no-multi \
            --prompt="branches> " --query "$argv" \
            --preview-window="right,65%" \
            --preview="git log -5 --graph --decorate --abbrev-commit --color=always {}")
    if test -n "$selected_branch"
        git switch (string replace --regex '^origin/' '' (string trim $selected_branch))
    end
    commandline --function repaint
end
