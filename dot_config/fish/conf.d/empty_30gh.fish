if not type -q gh ;or not type -q gopass
    exit 0
end

function gh_auth_login --description 'setup gh auth token from password-store'
    if test (count $argv) -eq 0
        echo 'no args'
        return
    end
    set -gx GH_TOKEN (gopass show --password $argv)
end

complete --command gh_auth_login --exclusive --arguments '(gopass list --flat)'
