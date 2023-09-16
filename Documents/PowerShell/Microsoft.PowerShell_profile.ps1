## Microsoft.PowerShell_profile.ps1
#
# 1. Edit $PROFILE.CurrentUserCurrentHost
# 2. Put the line below
#   ```
#   . ~/.config/powershell/Microsoft.PowerShell_profile.ps1
#   ```

# 文字化け対策
# https://smdn.jp/programming/netfx/tips/unicode_encoding_bom/
$OutputEncoding = [System.Text.Encoding]::Default
[System.Console]::OutputEncoding = [System.Text.Encoding]::Default
$Env:LC_ALL = "ja_JP.utf-8"

# ~/.local/bin を有効にする
$LocalBinDir = Join-Path -Path $Env:USERPROFILE -ChildPath ".local" -AdditionalChildPath "bin"
if (Test-Path $LocalBinDir)
{
	$Env:PATH = ($LocalBinDir, $Env:PATH) -join ";"
}

# Scoop Dir
$ScoopDir = Join-Path -Path $Env:USERPROFILE -ChildPath "scoop"
if ($Env:SCOOP)
{
	$ScoopDir = $Env:SCOOP
}
$ScoopShimsDir = Join-Path -Path $ScoopDir -ChildPath "shims"

$NonInteractive = ([Environment]::GetCommandLineArgs() | Where-Object { $_ -like '-NonI*' }).Length -gt 0
if ($NonInteractive)
{
	return
}

$CurrentUserScripts = Join-Path -Path $PSScriptRoot -ChildPath 'Scripts'
# $CurrentUserScripts = $PSGetPath.CurrentUserScripts

# $EDITOR を gVim にする
$Env:EDITOR = ((Get-Command gvim.exe).Source -replace '\\', '\\') + ' --remote-tab-silent-wait'

# VSCode 上の Integrated Terminal から起動した場合
if ($env:TERM_PROGRAM -eq "vscode")
{
	. "$(code --locate-shell-integration-path pwsh)"
}

# Self-Update
function Update-Self
{
	Start-Job -ScriptBlock {
		Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
	}
}

# PSReadLine
$PSReadLineOptions = @{
	BellStyle = "Visual"
	EditMode = "Emacs"
	HistorySearchCursorMovesToEnd = $true
	HistoryNoDuplicates = $true
}
Set-PSReadLineOption @PSReadLineOptions

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+i -Function TabCompleteNext
Set-PSReadLineKeyHandler -Key Ctrl+Shift+i -Function TabCompletePrevious
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardKillWord

## Prediction
try
{
	Set-PSReadLineOption -ErrorAction Stop -PredictionSource HistoryAndPlugin

	function GetBufferState
	{
		$line = $null
		$cursor = $null
		[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
		return $line, $cursor
	}

	Set-PSReadLineKeyHandler -Key Ctrl+f `
		-BriefDescription ForwardCharAndAcceptNextSuggestionWord `
		-ScriptBlock `
	{
		param($key, $arg)
		$line, $cursor = GetBufferState
		if ($cursor -lt $line.Length)
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
		} else
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
		}
	}

	Set-PSReadLineKeyHandler -Key Ctrl+e `
		-BriefDescription EndOnLineAndAcceptSuggestion `
		-ScriptBlock `
	{
		param($key, $arg)
		$line, $cursor = GetBufferState
		if ($cursor -lt $line.Length)
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine($key, $arg)
		} else
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
		}
	}
} catch
{
	Write-Warning "Update PsReadline: pwsh -NoProfile -Command ""Install-Module PSReadLine -Force -AllowPrerelease"""
}


# bat
$Env:BAT_CONFIG_PATH = (Resolve-Path "~/.config/bat/config").Path

# docker
$Env:DOCKER_HOST = "tcp://localhost:2375"

# fzf catppuccin theme
# https://github.com/catppuccin/fzf

## Latte
# $ENV:FZF_DEFAULT_OPTS=@"
# --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39
# --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78
# --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39
# "@

## Frappe
# $ENV:FZF_DEFAULT_OPTS=@"
# --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284
# --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf
# --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284
# "@

## Macchiato
# $ENV:FZF_DEFAULT_OPTS=@"
# --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
# --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
# --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
# "@

## Mocha
$ENV:FZF_DEFAULT_OPTS=@"
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"@

# Starship
. (Join-Path -Path $CurrentUserScripts -ChildPath 'Init-Starship.ps1')

# zoxide
. (Join-Path -Path $CurrentUserScripts -ChildPath 'Init-Zoxide.ps1')

# fnm
if (Get-Command -ErrorAction SilentlyContinue fnm | Out-Null)
{
	fnm env --shell power-shell | Out-String | Invoke-Expression
	function __fnm_hook
	{
		# spell-checker: disable-next-line
		If ((Test-Path .nvmrc) -Or (Test-Path .node-version))
		{
			& fnm use --silent-if-unchanged
		}
	}
	__fnm_hook
	fnm completions --shell power-shell | Out-String | Invoke-Expression
}

# Set-Location Hook
$ExecutionContext.InvokeCommand.LocationChangedAction = {
	if (Get-Command -ErrorAction SilentlyContinue -Type Function __fnm_hook)
	{
		__fnm_hook
	}
	if (Get-Command -ErrorAction SilentlyContinue -Type Function __zoxide_hook)
	{
		__zoxide_hook
	}
}

# wttr.in
function Get-Weather()
{
	Param(
		[string]$area = "Nagoya",
		[string]$options = "1")
	$url = "http://ja.wttr.in/" + $area + "?" + $options
	Write-Host (Invoke-WebRequest $url).Content
}
Set-Alias -Name wttr.in -Value Get-Weather

# Test-Colors
function Test-Colors
{
	& (Join-Path -Path $CurrentUserScripts -ChildPath 'Test-Colors.ps1')
}

# ghq + jzf
# https://uvb-76.hatenablog.com/entry/2020/02/14/032712
function Select-Repository
{
	try
	{
		$selected = $(ghq list | fzf --prompt="repository> " --reverse)
		if ($LastExitCode -ne 0)
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
			return
		}
		$path = ghq list --full-path $selected
		Set-Location $path
		[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
	} catch
	{
		Write-Warning "fzf, ghq: executables not installed"
	}
}

Set-Alias -Name fzf-ghq -Value Select-Repository

Set-PSReadLineKeyHandler -Chord Ctrl+q -ScriptBlock {
	Select-Repository
}

function Select-History
{
	try
	{
		$line = $null
		$cursor = $null
		[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
		$history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems() | ForEach-Object CommandLine
		[System.Collections.Generic.HashSet[String]] $historySet = $history
		$result = $historySet | fzf --prompt="history> " --reverse --scheme=history --tiebreak=index --tac --query="$line"
		if ($LastExitCode -ne 0)
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
			return
		}
		[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
		[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
		[Microsoft.PowerShell.PSConsoleReadLine]::Insert($result)
	} catch
	{
		Write-Warning "fzf: executables not installed"
	}
}

Set-Alias -Name fzf-history -Value Select-History

Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
	Select-History
}

function Select-Branch
{
	try
	{
		$targetBranch = $(git branch --all --format="%(refname:short)" | fzf --prompt="branch> " --reverse --preview-window="right,65%" --preview="git log --max-count=10 --graph --decorate --color=always --abbrev-commit --pretty {}")
		if ($LastExitCode -ne 0)
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
			return
		}
		& git switch ($targetBranch -replace "origin/", "")
		[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
	} catch
	{
		Write-Warning "fzf, git: executables not installed"
	}
}

Set-Alias -Name fzf-git-branch -Value Select-Branch

Set-PSReadLineKeyHandler -Chord Ctrl+g -ScriptBlock {
	Select-Branch
}

# AWS CLI のコマンド補完
if (Test-Path -ErrorAction Stop -Path (Join-Path -Path $ScoopShimsDir -ChildPath 'aws_completer.exe'))
{
	Register-ArgumentCompleter -Native -CommandName aws -ScriptBlock {
		param($commandName, $wordToComplete, $cursorPosition)
		$Env:COMP_LINE=$wordToComplete
		$Env:COMP_POINT=$cursorPosition
		aws_completer.exe | ForEach-Object {
			[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
		}
		Remove-Item Env:\COMP_LINE
		Remove-Item Env:\COMP_POINT
	}
}

# Windows デフォルトの curl を利用しない
function Initialize-Curl
{
	$CurlBin = Join-Path -Path $ScoopDir -ChildPath "apps" -AdditionalChildPath "curl", "current", "bin"
	if (Test-Path (Join-Path -Path $CurlBin -ChildPath "curl.exe"))
	{
		$Env:PATH = $CurlBin + ";" + $Env:PATH
	}
}
Initialize-Curl

# aliases

Set-Alias -Name open -Value Start-Process

# spell-checker: disable
$CoreutilsBin = @(
	"basename", "cat", "chmod", "comm", "cp", "cut", "date", "dirname", "echo",
	"env", "expr", "false", "fold", "head", "id", "install", "join", "ln", "ls",
	"md5sum", "mkdir", "mv", "od", "paste", "printf", "ps", "pwd", "rm",
	"rmdir", "sleep", "sort", "split", "stty", "tail", "tee", "touch", "tr",
	"true", "uname", "uniq", "wc",
	"grep")
# "msysmnt" is excluded from coreutils
$ReadonlyBin = @("tee", "diff", "ls", "sleep", "sort")
$ConfirmationRequiredBin = @("cp", "mv")
# spell-checker: enable
$CoreutilsBin | ForEach-Object {
	if (Test-Path Alias:$_)
	{
		if ($ReadonlyBin.Contains($_))
		{
			Remove-Item -Force -Path Alias:$_
		} else
		{
			Remove-Item -Path Alias:$_
		}
	}
}

function Unregister-GitCoreutilsShims
{
	& scoop shim rm ($CoreutilsBin -Join " ")
}

function Register-GitCoreutilsShims
{
	$ScoopGitBinDir = Join-Path -Path $ScoopDir -ChildPath "apps" -AdditionalChildPath "git", "current", "usr", "bin"
	$CoreutilsBin | ForEach-Object {
		$BinPath = Join-Path -Path $ScoopGitBinDir -ChildPath "$_.exe"
		if ($_ -eq "rm")
		{
			& scoop shim add $_ $BinPath '--' --interactive=once
		} elseif ($ConfirmationRequiredBin.Contains($_))
		{
			& scoop shim add $_ $BinPath '--' --interactive
		} else
		{
			& scoop shim add $_ $BinPath
		}
	}
}

if (Get-Command -Type Application -ErrorAction SilentlyContinue -Name eza)
{
	function global:ls
	{
		& eza.exe --classify --color=auto --color-scale --icons --ignore-glob='NTUSER.*|ntuser.*|Application Data|Local Settings|My Documents|Start Menu|スタート メニュー' $args
	}
} else
{
	function global:ls
	{
		& ls.exe --classify --color=auto --human-readable --dereference-command-line-symlink-to-dir --hide=_* --hide=.* --ignore=NTUSER.* --ignore=ntuser.* --ignore='Application Data' --ignore='Local Settings' --ignore='My Documents' --ignore='Start Menu' --ignore='スタート メニュー' --hide='*scoopappsyarncurrent*' $args
	}
}

# gsudo
try
{
	Import-Module -ErrorAction SilentlyContinue "gsudoModule.psd1"
} catch
{
}

# broot
if (Get-Command -ErrorAction SilentlyContinue "br")
{
} else
{
	. (Join-Path -Path $CurrentUserScripts -ChildPath 'Init-Broot.ps1')
}

# WinGet completion
# https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md#powershell
if (Get-Command -ErrorAction SilentlyContinue winget.exe | Out-Null)
{
	Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
		param($wordToComplete, $commandAst, $cursorPosition)
		[Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
		$Local:word = $wordToComplete.Replace('"', '""')
		$Local:ast = $commandAst.ToString().Replace('"', '""')
		winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
			[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
		}
	}
}

# Sleep Computer
function Suspend-Computer
{
	& (Join-Path -Path $CurrentUserScripts -ChildPath 'Suspend-Computer.ps1')
}

# Enable VS2019 Buildchain
function Enter-VsDevShell2019
{
	$Path = Join-Path -Path $CurrentUserScripts -ChildPath 'Start-VsDevShell.ps1'
	& $Path -PoshGit -Version "[16.0,17.0)"

	$Host.UI.RawUI.WindowTitle = "Developer PowerShell for VS2019"
}

# Enable VS2022
function Enter-VsDevShell2022
{
	$Path = Join-Path -Path $CurrentUserScripts -ChildPath 'Start-VsDevShell.ps1'
	& $Path -PoshGit -Version "[17.0,18.0)"

	$Host.UI.RawUI.WindowTitle = "Developer PowerShell for VS2022"
}

# Set wallpaper
function Set-RandomWallpaper
{
	$Path = Join-Path -Path $CurrentUserScripts -ChildPath 'Set-RandomWallpaper.ps1'
	Start-Job -FilePath $Path | Out-Null
}

# MS Teams のキャッシュを削除する
function Clear-MsTeamsCache
{
	$Path = Join-Path -Path $CurrentUserScripts -ChildPath 'Clear-MsTeamsCache.ps1'
	Start-Job -FilePath $Path | Out-Null
}

# WSL2 向けに Large Send Offload を無効にする
# docker pull が高速化される(かも)
function Disable-WslNetAdapterLso
{
	$Path = Join-Path -Path $CurrentUserScripts -ChildPath 'Disable-WslNetAdapterLso.ps1'
	Start-Process -Verb RunAs -FilePath "pwsh.exe" -ArgumentList "-c", $Path
}

# Catppuccin
try
{
	Import-Module Catppuccin

	function Set-CatppuccinTheme
	{
		param(
			[Parameter(Mandatory = $true)]
			[ValidateSet("Latte", "Frappe", "Macchiato", "Mocha")]
			[string] $Name
		)

		$Flavor = $Catppuccin[$Name]

		$ENV:FZF_DEFAULT_OPTS = @"
		--color=bg+:$($Flavor.Surface0),bg:$($Flavor.Base),spinner:$($Flavor.Rosewater)
		--color=hl:$($Flavor.Red),fg:$($Flavor.Text),header:$($Flavor.Red)
		--color=info:$($Flavor.Mauve),pointer:$($Flavor.Rosewater),marker:$($Flavor.Rosewater)
		--color=fg+:$($Flavor.Text),prompt:$($Flavor.Mauve),hl+:$($Flavor.Red)
		--color=border:$($Flavor.Surface2)
"@

		$Colors = @{
			# Largely based on the Code Editor style guide
			# Emphasis, ListPrediction and ListPredictionSelected are inspired by the Catppuccin fzf theme

			# Powershell colours
			ContinuationPrompt     = $Flavor.Teal.Foreground()
			Emphasis               = $Flavor.Red.Foreground()
			Selection              = $Flavor.Surface0.Background()

			# PSReadLine prediction colours
			InlinePrediction       = $Flavor.Overlay0.Foreground()
			ListPrediction         = $Flavor.Mauve.Foreground()
			ListPredictionSelected = $Flavor.Surface0.Background()

			# Syntax highlighting
			Command                = $Flavor.Blue.Foreground()
			Comment                = $Flavor.Overlay0.Foreground()
			Default                = $Flavor.Text.Foreground()
			Error                  = $Flavor.Red.Foreground()
			Keyword                = $Flavor.Mauve.Foreground()
			Member                 = $Flavor.Rosewater.Foreground()
			Number                 = $Flavor.Peach.Foreground()
			Operator               = $Flavor.Sky.Foreground()
			Parameter              = $Flavor.Pink.Foreground()
			String                 = $Flavor.Green.Foreground()
			Type                   = $Flavor.Yellow.Foreground()
			Variable               = $Flavor.Lavender.Foreground()
		}

		# Set the colours
		Set-PSReadLineOption -Colors $Colors

		# The following colors are used by PowerShell's formatting
		# Again PS 7.2+ only
		$PSStyle.Formatting.Debug = $Flavor.Sky.Foreground()
		$PSStyle.Formatting.Error = $Flavor.Red.Foreground()
		$PSStyle.Formatting.ErrorAccent = $Flavor.Blue.Foreground()
		$PSStyle.Formatting.FormatAccent = $Flavor.Teal.Foreground()
		$PSStyle.Formatting.TableHeader = $Flavor.Rosewater.Foreground()
		$PSStyle.Formatting.Verbose = $Flavor.Yellow.Foreground()
		$PSStyle.Formatting.Warning = $Flavor.Peach.Foreground()
	}
	Set-CatppuccinTheme 'Mocha'
} catch
{
}
