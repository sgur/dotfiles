type -q zellij || exit

function __zellij_hook --on-variable PWD
    set -l is_inside_work_tree (git rev-parse --is-inside-work-tree 2> /dev/null)

    if test $status -eq 0 && $is_inside_work_tree = true
        set -l repo_name (basename (git rev-parse --show-toplevel))
        if test "$ZELLIJ_TAB_NAME" != "$repo_name"
            set -gx ZELLIJ_TAB_NAME $repo_name
            zellij action rename-tab $repo_name
        end
        return
    end

    if test -n "$ZELLIJ_TAB_NAME"
        zellij action undo-rename-tab
        set -e ZELLIJ_TAB_NAME
    end
end
__zellij_hook
