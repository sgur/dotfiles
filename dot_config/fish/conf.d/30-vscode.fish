status is-interactive || exit

# https://code.visualstudio.com/docs/terminal/shell-integration
# code --locate-shell-integration-path fish

if string match -q "$TERM_PROGRAM" "vscode"

{{- $vscodeServer := glob (joinPath .chezmoi.homeDir ".vscode-server/bin/*/bin/remote-cli") | first -}}
{{ if $vscodeServer -}}
{{- $vscodeBase := joinPath ($vscodeServer | trimSuffix "/bin/remote-cli") "out" "vs" "workbench" "contrib" "terminal" "browser" "media" -}}
{{- $oldFishRc := joinPath $vscodeBase "shellIntegration.fish" -}}
{{   if stat $oldFishRc -}}
    source {{ $oldFishRc }}
{{-  end }}
{{- $newFishRc := joinPath $vscodeBase "fish_xdg_data" "fish" "vendor_conf.d" "shellIntegration.fish" -}}
{{   if stat $newFishRc }}
    source {{ $newFishRc }}
{{-   end }}
{{- end }}

end
