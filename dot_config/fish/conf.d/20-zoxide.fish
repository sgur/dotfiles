status is-interactive || exit

if type -q zoxide
    zoxide init fish | source
end
