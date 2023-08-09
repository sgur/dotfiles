## Microsoft.PowerShell_profile.ps1
#
# 1. Edit $PROFILE.CurrentUserCurrentHost
# 2. Put the line below
#   ```
#   . ~/.config/powershell/Microsoft.PowerShell_profile.ps1
#   ```

$CurrentUserScripts = Join-Path -Path $PSScriptRoot -ChildPath 'Scripts'
# $CurrentUserScripts = $PSGetPath.CurrentUserScripts

# Scoop Dir
$ScoopDir = (Join-Path -Path $Env:USERPROFILE -ChildPath "scoop")
if ($Env:SCOOP) {
	$ScoopDir = $Env:SCOOP
}
$ScoopShimsDir = Join-Path -Path $ScoopDir -ChildPath "shims"

# 文字化け対策
# https://smdn.jp/programming/netfx/tips/unicode_encoding_bom/
$OutputEncoding = [System.Text.Encoding]::Default
[System.Console]::OutputEncoding = [System.Text.Encoding]::Default
$Env:LC_ALL = "ja_JP.utf-8"

# $EDITOR を gVim にする
$Env:EDITOR = ((Get-Command gvim.exe).Source -replace '\\', '\\') + ' --remote-tab-silent-wait'

# VSCode 上の Integrated Terminal から起動した場合
if ($env:TERM_PROGRAM -eq "vscode") {
	. "$(code --locate-shell-integration-path pwsh)"
}

# Self-Update
function Update-Self {
	Start-Job -ScriptBlock {
		Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
	}
}

## PSReadLine
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

# Prediction
try {
	Set-PSReadLineOption -ErrorAction Stop -PredictionSource HistoryAndPlugin

	function GetBufferState {
		$line = $null
		$cursor = $null
		[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
		return $line, $cursor
	}

	Set-PSReadLineKeyHandler -Key Ctrl+f `
		-BriefDescription ForwardCharAndAcceptNextSuggestionWord `
		-ScriptBlock {
			param($key, $arg)
			$line, $cursor = GetBufferState
			if ($cursor -lt $line.Length) {
				[Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
			} else {
				[Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
			}
		}

	Set-PSReadLineKeyHandler -Key Ctrl+e `
		-BriefDescription EndOnLineAndAcceptSuggestion `
		-ScriptBlock {
			param($key, $arg)
			$line, $cursor = GetBufferState
			if ($cursor -lt $line.Length) {
				[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine($key, $arg)
			} else {
				[Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
			}
		}
} catch {
	Write-Warning "Update PsReadline: pwsh -NoProfile -Command ""Install-Module PSReadLine -Force -AllowPrerelease"""
}

## bat
$Env:BAT_CONFIG_PATH = (Resolve-Path "~/.config/bat/config").Path

## docker
$Env:DOCKER_HOST = "tcp://localhost:2375"

## Starship
try{
	Invoke-Expression -ErrorAction Stop (& starship init powershell --print-full-init | Out-String)
}
catch {
	Write-Warning "starship not found: scoop install starship"
}

## zoxide
try {
	Invoke-Expression -ErrorAction Stop (zoxide init --hook pwd powershell | Out-String)
	$Error.Clear()
}
catch {
	Write-Warning "zoxide not found: scoop install zoxide"
}

## fnm
try{
	Invoke-Expression -ErrorAction Stop (& fnm env | Out-String)
	function __fnm_hook {
		# spell-checker: disable-next-line
		If ((Test-Path .nvmrc) -Or (Test-Path .node-version)) {
			& fnm use --silent-if-unchanged
		}
	}
	__fnm_hook
	fnm completions | Out-String | Invoke-Expression
}
catch {
	Write-Warning "fnm not found: scoop install fnm"
}

## Set-Location Hook
$ExecutionContext.InvokeCommand.LocationChangedAction = {
	if (Get-Command -Type Function __fnm_hook) {
		__fnm_hook
	}
	if (Get-Command -Type Function __zoxide_hook) {
		__zoxide_hook
	}
}

## wttr.in
function Get-Weather() {
	Param(
		[string]$area = "Nagoya",
		[string]$options = "1")
	$url = "http://ja.wttr.in/" + $area + "?" + $options
	Write-Host (Invoke-WebRequest $url).Content
}
Set-Alias -Name wttr.in -Value Get-Weather

## Test-Colors
function Test-Colors {
	& (Join-Path -Path $CurrentUserScripts -ChildPath 'Test-Colors.ps1')
}

## ghq + jzf
# https://uvb-76.hatenablog.com/entry/2020/02/14/032712
function Select-Repository {
	try {
		$selected = $(ghq list | fzf --prompt="repository> " --reverse)
		if ($LastExitCode -ne 0) {
			[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
			return
		}
		$path = ghq list --full-path $selected
		Set-Location $path
		[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
	}
	catch {
		Write-Warning "fzf, ghq: executables not installed"
	}
}

Set-Alias -Name fzf-ghq -Value Select-Repository

Set-PSReadLineKeyHandler -Chord Ctrl+q -ScriptBlock {
	Select-Repository
}

function Select-History {
	try {
		$line = $null
		$cursor = $null
		[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
		$history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems() | ForEach-Object CommandLine
		[System.Collections.Generic.HashSet[String]] $historySet = $history
		$result = $historySet | fzf --prompt="history> " --reverse --scheme=history --tiebreak=index --tac --query="$line"
		if ($LastExitCode -ne 0) {
			[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
			return
		}
		[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
		[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
		[Microsoft.PowerShell.PSConsoleReadLine]::Insert($result)
	}
	catch {
		Write-Warning "fzf: executables not installed"
	}
}

Set-Alias -Name fzf-history -Value Select-History

Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
	Select-History
}

function Select-Branch {
	try {
		$targetBranch = $(git branch --all --format="%(refname:short)" | fzf --prompt="branch> " --reverse --preview-window="right,65%" --preview="git log --max-count=10 --graph --decorate --color=always --abbrev-commit --pretty {}")
		if ($LastExitCode -ne 0) {
			[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
			return
		}
		& git switch ($targetBranch -replace "origin/", "")
		[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
	}
	catch {
		Write-Warning "fzf, git: executables not installed"
	}
}

Set-Alias -Name fzf-git-branch -Value Select-Branch

Set-PSReadLineKeyHandler -Chord Ctrl+g -ScriptBlock {
	Select-Branch
}

## AWS CLI のコマンド補完
if (Test-Path -ErrorAction Stop -Path (Join-Path -Path $ScoopShimsDir -ChildPath 'aws_completer.exe')) {
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

## Windows デフォルトの curl を利用しない
function Initialize-Curl {
	$CurlBin = '~\scoop\apps\curl\current\bin\'
	if (Test-Path ($CurlBin + "curl.exe")) {
		$Env:PATH = $CurlBin + ";" + $Env:PATH
	}
}
Initialize-Curl

# aliases

Set-Alias -Name open -Value Start-Process

# spell-checker: disable
$CoreutilsBin = ("arch", "awk", "base32", "base64", "basename", "cat", "cksum", "comm", "cmp", "cp",
		"cut", "date", "df", "diff3", "dircolors", "dirname", "echo", "env", "expand",
		"expr", "factor", "false", "fmt", "fold", "gawk", "hashsum", "head", "hostname",
		"join", "link", "ln", "md5sum", "mkdir", "mktemp", "more", "mv",
		"nl", "nproc", "od", "paste", "printenv", "printf", "ptx", "pwd",
		"readlink", "realpath", "relpath", "rm", "rmdir", "sdiff", "sed", "seq", "sha1sum",
		"sha224sum", "sha256sum", "sha3-224sum", "sha3-256sum", "sha3-384sum",
		"sha3-512sum", "sha384sum", "sha3sum", "sha512sum", "shake128sum",
		"shake256sum", "shred", "shuf", "split", "sum", "sync",
		"tac", "tail", "test", "touch", "tr", "true", "truncate",
		"tsort", "unexpand", "uniq", "wc", "whoami", "yes")
# spell-checker: enable

## uutils-coreutils
if (Test-Path -ErrorAction Stop -Path (Join-Path -Path $ScoopShimsDir -ChildPath 'uutils.exe')) {
	try {
		$CoreutilsBin |
		ForEach-Object {
			if (Test-Path Alias:$_) { Remove-Item -Path Alias:$_ }
			$fn = '$input | uutils ' + $_ + ' $args'
			Invoke-Expression "function global:$_ { $fn }"
		}
		if (Test-Path Alias:ls) {
			Remove-Item -Path Alias:ls
		}
		function global:ls { uutils ls --classify=auto --color=auto --human-readable --dereference-command-line-symlink-to-dir --hide=_* --hide=.* --ignore=NTUSER.* --ignore=ntuser.* --ignore='Application Data' --ignore='Local Settings' --ignore='My Documents' --ignore='Start Menu' --ignore='スタート メニュー' --hide='*scoopappsyarncurrent*' $args }
	} catch {
		Write-Output $_.Exception.Message
	}
}
## msys from git
elseif (Test-Path -ErrorAction Stop -Path (Join-Path -Path $ScoopShimsDir -ChildPath 'scoop.ps1')) {
	$GitBinPath = (Join-Path -Path $ScoopDir -ChildPath 'apps' | Join-Path -ChildPath 'git' | Join-Path -ChildPath 'current' | Join-Path -ChildPath 'usr' | Join-Path -ChildPath 'bin')
	try {
		$CoreutilsBin |
		ForEach-Object {
			if (Test-Path Alias:$_) { Remove-Item -Path Alias:$_ }
			$fn = '$input | ' + (Join-Path -Path $GitBinPath -ChildPath $_) + '.exe $args'
			Invoke-Expression "function global:$_ { $fn }"
		}
		Invoke-Expression "function global:diff.exe { $('$input | ' + (Join-Path -Path $GitBinPath -ChildPath diff.exe) + ' $args') }"
		Invoke-Expression "function global:tee.exe { $('$input | ' + (Join-Path -Path $GitBinPath -ChildPath tee.exe) + ' $args') }"
		if (Test-Path Alias:ls) {
			Remove-Item -Path Alias:ls
		}
		$GitBinLsPath = (Join-Path -Path $GitBinPath -ChildPath 'ls.exe')
		function global:ls {
			& $GitBinLsPath --classify --color=auto --human-readable --dereference-command-line-symlink-to-dir --hide=_* --hide=.* --ignore=NTUSER.* --ignore=ntuser.* --ignore='Application Data' --ignore='Local Settings' --ignore='My Documents' --ignore='Start Menu' --ignore='スタート メニュー' --hide='*scoopappsyarncurrent*' $args
		}
	} catch {
		Write-Output $_.Exception.Message
	}
}

## gsudo
try {
	Import-Module -ErrorAction SilentlyContinue "gsudoModule.psd1"
} catch {}

## broot
if (Get-Command -ErrorAction SilentlyContinue "br") {
} elseif (Get-Command -ErrorAction SilentlyContinue "broot") {
	Invoke-Expression -ErrorAction Stop (broot --print-shell-function powershell | Out-String)
} else {
	Write-Output "broot not installed: scoop install broot"
}

## WinGet completion
# https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md#powershell
try {
	Get-Command -ErrorAction Stop winget.exe | Out-Null
	Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
	}
} catch {}

## Sleep Computer
function Suspend-Computer {
	& (Join-Path -Path $CurrentUserScripts -ChildPath 'Suspend-Computer.ps1')
}

## Enable VS2019 Buildchain
function Enter-VsDevShell2019 {
	$Path = Join-Path -Path $CurrentUserScripts -ChildPath 'Start-VsDevShell.ps1'
	& $Path -PoshGit -Version "[16.0,17.0)"

	$Host.UI.RawUI.WindowTitle = "Developer PowerShell for VS2019"
}

## Enable VS2022
function Enter-VsDevShell2022 {
	$Path = Join-Path -Path $CurrentUserScripts -ChildPath 'Start-VsDevShell.ps1'
	& $Path -PoshGit -Version "[17.0,18.0)"

	$Host.UI.RawUI.WindowTitle = "Developer PowerShell for VS2022"
}

## Set wallpaper
function Set-RandomWallpaper {
	$Path = Join-Path -Path $CurrentUserScripts -ChildPath 'Set-RandomWallpaper.ps1'
	Start-Job -FilePath $Path | Out-Null
}

## MS Teams のキャッシュを削除する
function Clear-MsTeamsCache {
	$Path = Join-Path -Path $CurrentUserScripts -ChildPath 'Clear-MsTeamsCache.ps1'
	Start-Job -FilePath $Path | Out-Null
}

## WSL2 向けに Large Send Offload を無効にする
# docker pull が高速化される(かも)
function Disable-WslNetAdapterLso {
	$Path = Join-Path -Path $CurrentUserScripts -ChildPath 'Disable-WslNetAdapterLso.ps1'
	Start-Process -Verb RunAs -FilePath "pwsh.exe" -ArgumentList "-c", $Path
}
