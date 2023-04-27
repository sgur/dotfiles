if not type -q bat
    exit 0
end

function bat_theme_preview_with
    if test (count $argv) -eq 0
        echo 'no args'
        return
    end
    bat --list-themes | fzf --preview="bat --theme={} --color=always $argv"
end

complete --command bat_theme_preview_with --require-parameter
