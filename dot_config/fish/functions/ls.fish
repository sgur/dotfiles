if type -q exa
    function ls --wraps=ls --description 'exa'
        command exa --color=auto --classify --icons $argv
    end
else
    function ls
        command ls --classify --human-readable --show-control-chars $argv
    end
end
