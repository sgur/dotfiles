status is-interactive || exit

# https://code.visualstudio.com/docs/terminal/shell-integration
# code --locate-shell-integration-path fish

string match -q "$TERM_PROGRAM" "vscode" || exit

set -l shell_integration ~/.vscode-server/bin/*/out/vs/workbench/contrib/terminal/browser/media/fish_xdg_data/fish/vendor_conf.d/shellIntegration.fish
if test -f $shell_integration
    source $shell_integration
    exit
end

set -l old_shell_integration ~/.vscode-server/bin/*/out/vs/workbench/contrib/terminal/browser/media/shellIntegration.fish
if test -f $old_shell_integration
    source $old_shell_integration
end
