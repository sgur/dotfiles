function ssh --wraps=ssh --description 'ssh with updating pinentry tty'
    if type -q gpg-connect-agent
        gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
    end
    command ssh $argv
end
