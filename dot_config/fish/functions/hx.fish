# helix editor
type -q hx; or exit 0

function hx --wraps=hx
    set -l lsp_dirs = ~/.local/share/vim-lsp-settings/servers/*
    set -l path $PATH $lsp_dirs
    PATH=$path command hx $argv
end