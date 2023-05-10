@echo off

setlocal
:parse
    if "%~1"=="" GOTO endparse
    if "%~1"=="--foo" (set _FOO=true)
    if "%~1"=="--bar" (set _BAR=true)
    if "%~1"=="--param" (set _PARAM=%~2)
    if "%~1"=="--param2" (set _PARAM2=%~2)
    shift
    GOTO parse
:endparse

if "%_FOO%"=="true" (
    echo --foo detected
)
if "%_BAR%"=="true" (
    echo --bar detected
)
if not "%_PARAM%"=="" (
    echo --param %_PARAM%
)
if not "%_PARAM2%"=="" (
    echo --param2 %_PARAM2%
)

endlocal
