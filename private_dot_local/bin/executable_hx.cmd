@ECHO off
SETLOCAL

@REM %USERPROFILE%\.local\share\vim-lsp-setttings\servers\* のフォルダーをPATHに追加する
SETLOCAL EnableDelayedExpansion
FOR /D %%i IN ("%USERPROFILE%\.local\share\vim-lsp-settings\servers\*") DO (
  SET "PATH=!PATH!;%%i"
)

hx.exe %*
