if test -n "$TMUX"; and type -q fzf-tmux
    # https://raw.githubusercontent.com/tmux/tmux/3.2/CHANGES
    # tmux 3.2 以降で popup が利用可能
    if test (string match --regex '\d(?:\.\d+)?' (tmux -V)) -ge 3.2
        set -gx FZF_CMD fzf-tmux -p 90%,40%
    else
        set -gx FZF_CMD fzf-tmux -d 40%
    end
else
    set -gx FZF_CMD fzf --height=40%
end


# fisher plugin
# https://github.com/decors/fish-ghq
bind \cq 'fzf_ghq_repository_select (commandline -b)'

# fisher plugin
# https://github.com/jethrokuan/fzf
bind \cr 'fzf_reverse_isearch'
