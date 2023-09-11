# kakoune editor
type -q kak; or exit 0

function kak --wraps=kak
    set -l lsp_dirs = ~/.local/share/vim-lsp-settings/servers/*
    set -l path $PATH $lsp_dirs
    PATH=$path SHELL=(which bash) command kak $argv
end
