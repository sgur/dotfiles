: <<EOF
@echo off
goto Windows
EOF
exec cmd //c "$0" $*
:Windows

:End
