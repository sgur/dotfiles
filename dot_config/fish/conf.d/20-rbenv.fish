if not type -q rbenv
    exit 0
end

status --is-interactive; and rbenv init - fish | source
