mkdir ~/.cache
if (not (which starship | is-empty)) {
    mkdir ~/.cache/starship
    starship init nu | save -f ~/.cache/starship/init.nu
}
if (not (which zoxide | is-empty)) {
    mkdir ~/.cache/zoxide
    zoxide init nushell | save -f ~/.cache/zoxide/init.nu
} 
