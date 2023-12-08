status is-interactive || exit

set -l os (uname -s)
# Linux
# Darwin
set -l arch (uname -m)
# x86_64
# arm64

if test $os = Darwin
    abbr rm rm -i
else
    abbr rm rm --interactive=once
end
abbr --add cp cp -i
abbr --add mv mv -i
abbr --add ipecho -- curl --silent ipecho.net/plain
abbr --add cu chezmoi update
abbr --add za zellij attach
abbr --add za-c -- zellij attach --create
abbr --add zl zellij list-sessions

# abbr --add CC --position anywhere --set-cursor "% | fish_clipboard_copy"
abbr --add aws.e --set-cursor "aws-vault exec % -- "
abbr --add aws.l --set-cursor "aws-vault login % --stdout | fish_clipboard_copy"

abbr --add pwsh /mnt/c/Program\\ Files/PowerShell/7/pwsh.exe

abbr --add hostname uname -n

abbr --add secretlint -- 'docker run -v (pwd):(pwd) -w (pwd) --rm -it secretlint/secretlint secretlint "**/*"'
