# PowerShell Console

# $Env:CHEZMOI_GITHUB_ACCESS_TOKEN が定義されていなかったらWarningを出す
if (-not $Env:CHEZMOI_GITHUB_ACCESS_TOKEN)
{
	Write-Warning "Environment variable 'CHEZMOI_GITHUB_ACCESS_TOKEN' is not defined."
}

$Ext = @{}
$IsEmojiSupported = $Env:WT_SESSION -Or $Env:ALACRITTY_LOG

$NonInteractive = ([Environment]::GetCommandLineArgs() | Where-Object { $_ -like '-NonI*' }).Length -gt 0
if ($NonInteractive)
{
	return
}

$CurrentUserScripts = Join-Path -Path $PSScriptRoot -ChildPath 'Scripts'
# $CurrentUserScripts = $PSGetPath.CurrentUserScripts

$Env:PATH = @([IO.PATH]::Combine($Env:ProgramFiles, "Vim", "vim91"), $Env:PATH) -join [IO.PATH]::PathSeparator
$Env:EDITOR = "gvim.exe -f --remote-tab-wait-silent"

# VSCode 上の Integrated Terminal から起動した場合
if ($Env:TERM_PROGRAM -eq "vscode")
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

try
{
	Set-PSReadLineOption -TerminateOrphanedConsoleApps
} catch
{
	Write-Warning "Updates needed: pwsh -NoProfile -Command ""Update-Module PSReadLine -Force -AllowPrerelease"""
}

Set-Alias -Name chz -Value chezmoi

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

# chezmoi completions
if (Get-Command -Type Application -ErrorAction SilentlyContinue -Name chezmoi)
{
	. (Join-Path -Path $CurrentUserScripts -ChildPath 'Complete-Chezmoi.ps1')
}

# xh completions
if (Get-Command -Type Application -ErrorAction SilentlyContinue -Name xh)
{
	$Ext.xh = $true
	. (Join-Path -Path $CurrentUserScripts -ChildPath 'Complete-Xh.ps1')
} else
{
	$Ext.xh = $false
}


# bat
$Env:BAT_CONFIG_PATH = (Resolve-Path "~/.config/bat/config").Path

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

# hgrep
if (Get-Command -ErrorAction SilentlyContinue hgrep)
{
	$Env:HGREP_DEFAULT_OPTS = '--theme Nord'
	. (Join-Path -Path $CurrentUserScripts -ChildPath 'Complete-Hgrep.ps1')
}

# Starship
if ($IsEmojiSupported)
{
	if (Get-Command -Type Application -ErrorAction SilentlyContinue -Name starship)
	{
		$Ext.starship = $true
		. (Join-Path -Path $CurrentUserScripts -ChildPath 'Init-Starship.ps1')
	}
	else
	{
		$Ext.starship = $false
	}
}

# zoxide
if (Get-Command -ErrorAction SilentlyContinue zoxide)
{
	$Ext.zoxide = $true
	. (Join-Path -Path $CurrentUserScripts -ChildPath 'Init-Zoxide.ps1')
}
else
{
	$Ext.zoxide = $false
}

# Set-Location Hook
$ExecutionContext.InvokeCommand.LocationChangedAction = {
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
		$selected = $(ghq list | fzf --prompt="repository> ")
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

Set-PSReadLineKeyHandler -Chord Alt+q -ScriptBlock {
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
		$result = $historySet | fzf --prompt="history> " --scheme=history --tiebreak=index --tac --query="$line"
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
		$targetBranch = $(git branch --all --format="%(refname:short)" | fzf --prompt="branch> " --preview-window="right,65%" --preview="git log --max-count=10 --graph --decorate --color=always --abbrev-commit --pretty {}")
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

Set-PSReadLineKeyHandler -Chord Alt+a -ScriptBlock {
	Select-Branch
}

function Select-ZoxideHistory
{
	try {
		$Path = $(zoxide query --list | fzf --prompt="zoxide> ")
		if ($LastExitCode -ne 0)
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
			return
		}
		Set-Location $Path
		[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
	} catch
	{
		Write-Warning "fzf, ghq: executables not installed"
	}
}

Set-Alias -Name fzf-zoxide -Value Select-ZoxideHistory

Set-PSReadLineKeyHandler -Chord Alt+z -ScriptBlock {
	Select-ZoxideHistory
}

# aliases

Set-Alias -Name open -Value Start-Process

# spell-checker: disable
$CoreutilsBin = @("basename", "cat", "chmod", "comm", "cp", "cut", "cygpath",
	"date", "diff", "dirname", "echo", "env", "expr", "false", "fold", "grep",
	"head", "id", "install", "join", "ln", "md5sum", "mkdir", "mv", "od",
	"paste", "printf", "ps", "pwd", "rm", "rmdir", "sleep", "sort", "split", "stty",
	"tail", "tee", "touch", "tr", "true", "uname", "uniq", "wc", "iconv")
# "msysmnt" is excluded from coreutils
$ReadonlyBin = @("tee", "diff", "ls", "sleep", "sort")
$ConfirmationRequiredBin = @("cp", "mv")
# spell-checker: enable
try {
	$GitBinDir = Get-Command -Type Application -Name git
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
	if ($GitBinDir.Source -like '*\Microsoft\WinGet\*') {
		$GitDir = $GitBinDir | Split-Path -Parent | Split-Path -Parent
		$BusyBoxPath = Join-Path -Path $GitDir -ChildPath "Packages" "Git.MinGit.BusyBox_Microsoft.Winget.Source_8wekyb3d8bbwe" "mingw64" "bin" "busybox.exe"
		Set-Alias -Name busybox -Value $BusyBoxPath
		$CoreutilsBin | ForEach-Object {
			$Flag = @("cp", "mv", "rm").contains($_) ? "-i" : ""
			@"
			function global:$_
			{
				& $BusyBoxPath $_ $Flag `$args
			}
"@ | Invoke-Expression
		}
	} else
	{
		$GitDir = $GitBinDir | Split-Path -Parent | Split-Path -Parent
		$CoreutilsBin | ForEach-Object {
			$BinPath = Join-Path -Path $GitDir -ChildPath "usr" "bin" "$_.exe"
			if (@("cp", "mv").contains($_))
			{
				@"
				function global:$_
				{
					& "$BinPath" --interactive `$args
				}
"@ | Invoke-Expression
			}
			elseif ($_ -eq "rm")
			{
				@"
				function global:rm
				{
					& "$BinPath" --interactive=once `$args
				}
"@ | Invoke-Expression
			} else
			{
				Set-Alias -Name $_ -Value $BinPath
			}
		}
	}
}
finally {
	Remove-Variable -Name GitBinDir, GitDir
}

if (Get-Command -Type Application -ErrorAction SilentlyContinue -Name eza)
{
	$Ext.eza = $true
	Remove-Item -Force -Path Alias:ls
	$IconOption = $IsEmojiSupported ? "--icons" : $null
	function global:ls
	{
		& eza.exe --classify --color=auto --color-scale=size $IconOption --no-quotes --group-directories-first `
			--ignore-glob='NTUSER.*|ntuser.*|Application Data|Local Settings|My Documents|Start Menu|スタート メニュー' $args
	}
} else
{
	$Ext.eza = $false
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
	if (Get-Command -ErrorAction SilentlyContinue "broot")
	{
		$Ext.broot = $true
		. (Join-Path -Path $CurrentUserScripts -ChildPath 'Init-Broot.ps1')
	}
	else
	{
		$Ext.broot = $false
	}
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
	Set-CatppuccinTheme 'Macchiato'
} catch
{
}

# Login via aws-vault
# https://adamtheautomator.com/powershell-validateset/#Using_a_Class_for_a_ValidateSet_Value_List_A_Real_Example
class AwsProfiles : System.Management.Automation.IValidateSetValuesGenerator
{
	[string[]] GetValidValues()
	{
		return wsl.exe --shell-type login -- aws configure list-profiles
	}
}
function Start-AwsConsole
{
	param(
		[Parameter(Mandatory = $true)]
		[ValidateSet([AwsProfiles])]
		[string] $Profile
	)
	$Token = wsl.exe --shell-type login -- aws-vault login --duration=4h $Profile --stdout
	rundll32.exe url.dll,FileProtocolHandler $Token
}

function Invoke-AwsVault
{
	param(
		[Parameter(Mandatory, Position = 0)]
		[ValidateSet([AwsProfiles])]
		[string] $AwsProfile,
		[Parameter(Mandatory, Position = 1)]
		[System.Management.Automation.ScriptBlock] $ScriptBlock
	)
	$AccessKeyId = $Env:AWS_ACCESS_KEY_ID
	$SecretAccessKey = $Env:AWS_SECRET_ACCESS_KEY
	$Sessiontoken = $Env:AWS_SESSION_TOKEN
	$Expiration = $Env:AWS_CREDENTIAL_EXPIRATION
	try
	{
		$EnvJson = wsl.exe --shell-type login -- aws-vault export $AwsProfile --format=json | ConvertFrom-Json
		$Env:AWS_ACCESS_KEY_ID = $EnvJson.AccessKeyId
		$Env:AWS_SECRET_ACCESS_KEY = $EnvJson.SecretAccessKey
		$Env:AWS_SESSION_TOKEN = $EnvJson.Sessiontoken
		$Env:AWS_CREDENTIAL_EXPIRATION=$EnvJson.Expiration.ToString('O')
		Invoke-Command -ScriptBlock $ScriptBlock
	} finally
	{
		$Env:AWS_ACCESS_KEY_ID = $AccessKeyId
		$Env:AWS_SECRET_ACCESS_KEY = $SecretAccessKey
		$Env:AWS_SESSION_TOKEN = $Sessiontoken
		$Env:AWS_CREDENTIAL_EXPIRATION=$Expiration
	}
}

# proto
$env:PROTO_HOME = Join-Path $HOME ".proto"
$env:PATH = @(
  (Join-Path $env:PROTO_HOME "shims"),
  (Join-Path $env:PROTO_HOME "bin"),
  $env:PATH
) -join [IO.PATH]::PathSeparator
if (Get-Command -Type Application -ErrorAction SilentlyContinue -Name proto)
{
	$Ext.proto = $true
	. (Join-Path -Path $CurrentUserScripts -ChildPath 'Complete-Proto.ps1')
} else
{
	$Ext.proto = $false
}

$Buffer = New-Object System.Text.StringBuilder
$Ext.GetEnumerator() | Sort-Object -Property Key | ForEach-Object {
	[void] $Buffer.Append(" ")
	if ($IsEmojiSupported) {
		if ($_.Value)
		{
			[void] $Buffer.Append("✔ ")
		}
	}
	else
	{
		if (!$_.Value)
		{
			[void] $Buffer.Append("[N/A]")
		}
	}
	[void] $Buffer.Append($_.Key)
}
Write-Host $Buffer.ToString()

Remove-Variable -Name NonInteractive, Buffer, Ext, IsEmojiSupported

