@REM このファイルは %LocalAppData%\clink に保存する
@echo off

@doskey ls=ls.exe -F --ignore="NTUSER.DAT*" --ignore="My Documents" --ignore="Application Data" --ignore="Local Settings" $*
