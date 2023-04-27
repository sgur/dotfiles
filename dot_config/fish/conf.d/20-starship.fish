if not status --is-interactive
    exit
end

if type -q starship
    starship init fish | source
end
