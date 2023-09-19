# helix editor
type -q hx; or exit 0

function hx --wraps=hx
    set -l lsp_dirs ~/.local/share/vim-lsp-settings/servers/*
    set -l path $lsp_dirs $PATH
    PATH=$path SHELL=(which bash) command hx $argv
end
