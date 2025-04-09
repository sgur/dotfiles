status is-interactive || exit

type -q pass || exit
set -gx PASSWORD_STORE_ENABLE_EXTENSIONS true
