status is-interactive || exit

set -l os (uname -s)
# Linux
# Darwin
set -l arch (uname -m)
# x86_64
# arm64

if test $os = "Linux"
    abbr rm rm -i
else
    abbr rm rm --interactive=once
end
abbr cp cp -i
abbr mv mv -i
abbr ipecho curl --silent ipecho.net/plain
abbr cu chezmoi update
abbr za-c zellij attach --create
abbr zl zellij list-sessions
