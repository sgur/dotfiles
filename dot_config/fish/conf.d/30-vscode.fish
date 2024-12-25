status is-interactive || exit

# https://code.visualstudio.com/docs/terminal/shell-integration
# code --locate-shell-integration-path fish

string match -q "$TERM_PROGRAM" vscode || exit

test -n "$TMUX" && set -e TMUX
test -n "$TMUX_PANE" && set -e TMUX_PANE
test -n "$TMUX_PLUGIN_MANAGER_PATH" && set -e TMUX_PLUGIN_MANAGER_PATH

test -n "$ZELLIJ" && set -e ZELLIJ
test -n "$ZELLIJ_PANE_ID" && set -e ZELLIJ_PANE_ID
test -n "$ZELLIJ_SESSION_NAME" && set -e ZELLIJ_SESSION_NAME

set -l scripts \
    ~/.vscode-server/bin/*/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish \
    ~/.vscode-server/bin/*/out/vs/workbench/contrib/terminal/browser/media/fish_xdg_data/fish/vendor_conf.d/shellIntegration.fish \
    ~/.vscode-server/bin/*/out/vs/workbench/contrib/terminal/browser/media/shellIntegration.fish
for shell_integration in $scripts
    if test -f $shell_integration
        source $shell_integration
        break
    end
end
