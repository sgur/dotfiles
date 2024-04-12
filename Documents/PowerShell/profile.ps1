# Common

# 文字化け対策
# https://smdn.jp/programming/netfx/tips/unicode_encoding_bom/
$OutputEncoding = [System.Text.Encoding]::Default
[System.Console]::OutputEncoding = [System.Text.Encoding]::Default
$Env:LC_ALL = "ja_JP.utf-8"

# ~/.local/bin を有効にする
$LocalBinDir = Join-Path -Path $Env:USERPROFILE -ChildPath ".local" -AdditionalChildPath "bin"
if (Test-Path $LocalBinDir)
{
	$Env:PATH = @($LocalBinDir, $Env:PATH) -join [IO.PATH]::PathSeparator
}

# docker
$Env:DOCKER_HOST = "tcp://localhost:2375"
