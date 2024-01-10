status is-interactive || exit
status is-login || exit
type -q gopass || exit

if test -d ~/.local/share/gopass/
    function handler --on-event fish_exit
        if test (math (date +%s) - (path mtime ~/.local/share/gopass/stores/root/.git/FETCH_HEAD)) -gt (math 60 '*' 60)
            gopass sync
        end
    end
end
 
