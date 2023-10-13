# kakoune editor
type -q kak; or exit 0

function kak --wraps=kak
    SHELL=(which bash) command kak $argv
end
