# kakoune editor
type -q kak; or exit 0

function kak --wraps=kak
    set -l lsp_dirs ~/.local/share/vim-lsp-settings/servers/*
    set -l path $lsp_dirs $PATH
    PATH=$path SHELL=(which bash) command kak $argv
end
