status is-interactive || exit

set -l os (uname -s)
# Linux
# Darwin
set -l arch (uname -m)
# x86_64
# arm64

if test $os = Darwin
    abbr rm "rm -i"
else
    abbr --add rm "rm --interactive=once"
end
abbr --add cp "cp -i"
abbr --add mv "mv -i"
abbr --add curl /usr/bin/curl
abbr --add ipecho -- /usr/bin/curl --silent ipecho.net/plain

abbr --add za zellij attach
abbr --add za-c -- zellij attach --create
abbr --add zl zellij list-sessions

abbr --add ce-a -- chezmoi edit --apply
abbr --add cu -- chezmoi update
abbr --add ca -- chezmoi apply
abbr --add cra -- chezmoi re-add

# abbr --add CC --position anywhere --set-cursor "% | fish_clipboard_copy"
abbr --add aws.e --set-cursor "aws-vault exec % -- "
abbr --add aws.l --set-cursor "aws-vault login % --stdout | fish_clipboard_copy"

abbr --add hostname uname -n

abbr --add plantuml-server docker container run --detach --publish 9999:8080 --name plantuml-server --restart=always plantuml/plantuml-server:jetty
abbr --add --set-cursor sws docker run --rm -it -p 8787:80 -v %:/public joseluisq/static-web-server:2
