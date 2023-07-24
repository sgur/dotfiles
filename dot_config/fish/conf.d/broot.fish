status is-interactive || exit

if not type -q broot
    exit 0
end

broot --print-shell-function fish | source
