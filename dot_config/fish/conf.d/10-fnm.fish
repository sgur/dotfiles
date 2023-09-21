status is-interactive || exit

type -q fnm || exit

fnm env --use-on-cd | source
