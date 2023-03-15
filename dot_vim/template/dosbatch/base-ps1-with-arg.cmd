@(echo '> NUL
echo off)
setlocal
set "COMMAND_PATH=%~f0"
set "ARG_1=%~1"
PowerShell -Command "Invoke-Expression -Command ((Get-Content \"%COMMAND_PATH:`=``%\") -join \"`n\")"
exit /b %errorlevel%
') | Out-Null

$args += $Env:ARG_1
$PSCommandPath = $Env:COMMAND_PATH

{{_cursor_}}
