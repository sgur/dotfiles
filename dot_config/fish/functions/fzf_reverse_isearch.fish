function fzf_reverse_isearch --description 'Search history'
    history merge
    history | $FZF_CMD --reverse --prompt="history> " --scheme=history --tiebreak=index --height 40% --query "$argv" | read select
    and commandline -- $select
    commandline -f repaint
end
