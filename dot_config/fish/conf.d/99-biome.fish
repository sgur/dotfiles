function enable_biome_default_config --on-event fish_preexec
    set -l toplevel (git rev-parse --show-toplevel 2> /dev/null)
    if test \( $status -eq 0 \) -a \( -e "./biome.json" -o -e "./biome.jsonc" \)
        set -e BIOME_CONFIG_PATH
    else if test \( $status -eq 0 \) -a \( -e "$toplevel/biome.json" -o -e "$toplevel/biome.jsonc" \)
        set -e BIOME_CONFIG_PATH
    else
        set -gx BIOME_CONFIG_PATH ~/.config/
    end
end
