function fzf_zoxide_select
    set -l dir (zoxide query --list \
        | $FZF_CMD --reverse --no-multi --prompt="mru> " --query "$argv" \
        --scheme=path \
        --preview-window="right,50%" \
        --preview='ls -1 {}')
    if test -n "$dir"
        cd "$dir"
    end
    commandline --function repaint
end
