function fzf_zoxide_select
    set -l dir (zoxide query --list \
        | $FZF_CMD --reverse --no-multi --prompt="zoxide> " --query "$argv" \
        --scheme=path \
        --preview-window="right,40%" \
        --preview='ls -1 {}')
    if test -n "$dir"
        cd "$dir"
    end
    commandline --function repaint
end
