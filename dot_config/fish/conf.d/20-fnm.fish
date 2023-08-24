if not type -q fnm
    exit 0
end

fnm env --use-on-cd | source
