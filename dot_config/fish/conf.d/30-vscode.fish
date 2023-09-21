status is-interactive || exit

if test "$TERM_PROGRAM" != "vscode"
     exit
 end

set -l vscode_server (string match '*/.vscode-server/*/bin/remote-cli' $PATH)[1]
if test -n $vscode_server
    set -l vscode_base (string replace '/bin/remote-cli' '' $vscode_server)'/out/vs/workbench/contrib/terminal/browser/media'
    set -l old_fishrc $vscode_base'/shellIntegration.fish'
    if test -f $old_fishrc
        source $old_fishrc
    end
    set -l new_fishrc $vscode_base'/fish_xdg_data/fish/vendor_conf.d/shellIntegration.fish'
    if test -f $new_fishrc
        source $new_fishrc
    end
end
