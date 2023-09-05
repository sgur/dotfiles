if (not (which starship | is-empty)) {
    source ~/.cache/starship/init.nu
}
if (not (which zoxide | is-empty)) {
    source ~/.cache/zoxide/init.nu
} 

let keybindings = $env.config.keybindings | append [
    {
        name: newline_or_run_command
        modifier: control
        keycode: char_m
        mode: [emacs, vi_normal, vi_insert]
        event: { send: enter }
    }
    {
        name: completion_menu
        modifier: control
        keycode: char_i
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                { send: menu name: completion_menu }
                { send: menunext }
            ]
        }
    }
]
$env.config = ($env.config
    | upsert show_banner false
    | upsert table.mode compact
    | upsert keybindings $keybindings)

