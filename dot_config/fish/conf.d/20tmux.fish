if test -n "$TMUX"
    stty stop undef
end

if test -f /etc/os-release
    cat /etc/os-release | read -s -l os_name
    if string match --quiet '*"openSUSE Tumbleweed"' $os_name
        set -gx TMUX_TMPDIR /tmp
    end
end

