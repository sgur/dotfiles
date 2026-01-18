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

# 7-Zip cli
if (!(Get-Command -Type Application -ErrorAction SilentlyContinue -Name 7z))
{
	$Env:PATH = @([IO.PATH]::Combine($Env:ProgramFiles, "7-Zip"), $Env:PATH) -join [IO.PATH]::PathSeparator
}

# gvim
if (!(Get-Command -Type Application -ErrorAction SilentlyContinue -Name gvim))
{
	$Env:PATH = @([IO.PATH]::Combine($Env:ProgramFiles, "Vim", "vim91"), $Env:PATH) -join [IO.PATH]::PathSeparator
}

# docker
$Env:DOCKER_HOST = "tcp://localhost:2375"

# ripgrep
$Env:RIPGREP_CONFIG_PATH = Join-Path $Env:USERPROFILE .config ripgrep ripgreprc

# bat
$Env:BAT_CONFIG_PATH = Join-Path $Env:USERPROFILE .config bat config

# fzf catppuccin theme
# https://github.com/catppuccin/fzf

## Latte
# $Env:FZF_DEFAULT_OPTS=@"
# --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39
# --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78
# --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39
# "@

## Frappe
# $Env:FZF_DEFAULT_OPTS=@"
# --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284
# --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf
# --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284
# "@

## Macchiato
# $Env:FZF_DEFAULT_OPTS=@"
# --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
# --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
# --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
# "@

## Mocha
$Env:FZF_DEFAULT_OPTS=@"
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"@
