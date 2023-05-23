status is-interactive || exit

if type -q starship
    starship init fish | source
end
