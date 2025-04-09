status is-interactive || exit

type -q pass-otp || exit
set -gx PASSWORD_STORE_ENABLE_EXTENSIONS true
