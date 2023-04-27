if test "$WSL_DISTRO_NAME" = 'Debian' ;or test -f /etc/debian_version
    if not type -q lsb_release
        echo "sudo apt install lsb-release"
        exit 0
    end
    if string match --quiet '*Debian' (lsb_release --id)
        set -gx FISH_UNIT_TESTS_RUNNING 1
    end
end

