if (not (which starship | is-empty)) {
    source ~/.cache/starship/init.nu
}
if (not (which zoxide | is-empty)) {
    source ~/.cache/zoxide/init.nu
} 

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

