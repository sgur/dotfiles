# helix editor
type -q hx; or exit 0

function hx --wraps=hx
    SHELL=(which bash) command hx $argv
end
