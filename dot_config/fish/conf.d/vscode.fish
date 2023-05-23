status is-interactive || exit

# string match -q "$TERM_PROGRAM" "vscode"
# and . (code --locate-shell-integration-path fish)
if test "$TERM_PROGRAM" != "vscode"
     exit
 end

set -l vscode_server (string match '*/.vscode-server/*/bin/remote-cli' $PATH)[1]
if test -n $vscode_server
    . (string replace '/bin/remote-cli' '' $vscode_server)'/out/vs/workbench/contrib/terminal/browser/media/shellIntegration.fish'
end
