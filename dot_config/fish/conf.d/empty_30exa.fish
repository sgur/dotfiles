## exa
# https://the.exa.website/
#

if type -q exa
    function ls --wraps=ls --description 'exa'
        command exa --color=auto --classify --icons $argv
    end
end
