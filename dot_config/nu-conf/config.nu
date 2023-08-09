mkdir ~/.cache
if (not (which starship | is-empty)) {
    mkdir ~/.cache/starship
    starship init nu | save -f ~/.cache/starship/init.nu
}
if (not (which zoxide | is-empty)) {
    mkdir ~/.cache/zoxide
    zoxide init nushell | save -f ~/.cache/zoxide/init.nu
} 
source ~/.cache/starship/init.nu
source ~/.cache/zoxide/init.nu

let keybindings = $env.config.keybindings | append [{
        name: new-line
        modifier: control
        keycode: char_m
        mode: [emacs, vi_normal, vi_insert]
        event: { send: Enter }
    }]
$env.config = ($env.config
    | upsert show_banner false
    | upsert table.mode compact
    | upsert keybindings $keybindings)

