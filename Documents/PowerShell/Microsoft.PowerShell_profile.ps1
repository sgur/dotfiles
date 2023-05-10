## Microsoft.PowerShell_profile.ps1
#
# 1. Edit $PROFILE.CurrentUserCurrentHost
# 2. Put the line below
#   ```
#   . ~/.config/powershell/Microsoft.PowerShell_profile.ps1
#   ```

# Scoop Dir
$ScoopDir = (Join-Path -Path $Env:USERPROFILE -ChildPath "scoop")
if ($Env:SCOOP) {
	$ScoopDir = $Env:SCOOP
}
$ScoopShimsDir = Join-Path -Path $ScoopDir -ChildPath "shims"

# 文字化け対策
$OutputEncoding = [Text.UTF8Encoding]::UTF8
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
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
# https://stackoverflow.com/a/20588680
function Test-Colors( ) {
	$Colors = [Enum]::GetValues( [ConsoleColor] )
	$Max = ($Colors | ForEach-Object { "$_ ".Length } | Measure-Object -Maximum).Maximum
	foreach( $Color in $Colors ) {
		Write-Host (" {0,2} {1,$Max} " -f [int]$color,$color) -NoNewline
		Write-Host "  " -Background $color -NoNewline
		Write-Host " " -NoNewline
		Write-Host "$Color" -Foreground $color
	}
}

## ghq + jzf
# https://uvb-76.hatenablog.com/entry/2020/02/14/032712
function Select-Repository {
	try {
		$repo = $(ghq list | fzf --prompt="repository> " --reverse)
		if ($LastExitCode -ne 0) {
			[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
			return
		}
		$path = ghq list --full-path --exact $repo
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

## Sleep Computer
function Suspend-Computer {
	$signature = @"
[DllImport("powrprof.dll")]
public static extern bool SetSuspendState(bool Hibernate, bool ForceCritical, bool DisableWakeEvent;
"@
	$func = Add-Type -MemberDefinition $signature -Namespace "Win32Functions" -Name "SetSuspendStateFunction" -PassThru
	$func::SetSuspendState($false, $false, $true)
}

function __VsDevShell {
	param (
		[Parameter(Mandatory=$true)][string]$Version,
		[Switch]$PoshGit
	)

	try {
		$VsWhereCmd =(Join-Path ${Env:ProgramFiles(x86)} '\\Microsoft Visual Studio\\Installer\\vswhere.exe')
		$Param = ConvertFrom-Json ([string] (&$VsWhereCmd -version $Version -format json))
		Import-Module -ErrorAction Stop (Join-Path $Param.installationPath 'Common7\\Tools\\Microsoft.VisualStudio.DevShell.dll')
		Enter-VsDevShell $Param.instanceId -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"
	} catch {
		Write-Warning "Visual Studio: not installed"
		return
	}

	if ($PoshGit) {
		try {
			Import-Module -ErrorAction Stop posh-git
		} catch {
			Write-Warning "posh-git not found: Install-Module posh-git"
		}
	}
}

## Enable VS2019 Buildchain
function Enter-VsDevShell2019 {
	__VsDevShell -PoshGit -Version "[16.0,17.0)"

	$Host.UI.RawUI.WindowTitle = "Developer PowerShell for VS2019"
}

## Enable VS2022
function Enter-VsDevShell2022 {
	__VsDevShell -PoshGit -Version "[17.0,18.0)"

	$Host.UI.RawUI.WindowTitle = "Developer PowerShell for VS2022"
}


## Set wallpaper
function Set-RandomWallpaper {
	$Src = {
		if (-not ('Wallpaper' -as [type])) {
			$WallpaperTypeSource =
@"
using System.Runtime.InteropServices;
public class Wallpaper
{
	public const int SPI_SETDESKWALLPAPER = 0x0014;
	public const int SPIF_UPDATEINIFILE = 0x01;
	public const int SPIF_SENDWININICHANGE = 0x02;

	[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
	private static extern int SystemParametersInfo (int uAction, int uParam, string pvParam, int fWinIni);

	public static void SetWallpaper ( string path )
	{
		SystemParametersInfo( SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE );
	}
}
"@
			Add-Type -TypeDefinition $WallpaperTypeSource
		}
		if (-not ('System.Windows.Forms.Screen' -as [type])) {
			Add-Type -AssemblyName System.Windows.Forms
		}
		$WorkingArea = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
		$Uri = "https://source.unsplash.com/random/$($WorkingArea.Width)x$($WorkingArea.Height)/?wallpaper,landscape"

		$OutputFormat = "${Env:TEMP}\Wallpaper_{0}.jpeg"
		$OldFiles = $OutputFormat -f "*" | Get-ChildItem
		try {
			$HttpClient = New-Object System.Net.Http.HttpClient
			$Task = $HttpClient.GetAsync($Uri)
			$Response = $Task.GetAwaiter().GetResult()
			if (!$Response.IsSuccessStatusCode){
				return
			}
			$ImgUri = $Response.RequestMessage.RequestUri

			$OutputFile = $OutputFormat -f (Get-Random)
			Set-Content -AsByteStream -Value $Response.Content.ReadAsByteArrayAsync().Result -Path $OutputFile

			$Queries = @{}
			foreach ($q in $Response.RequestMessage.RequestUri.Query.Substring(1).Split('&')) {
				$kv = $q.split('=')
				$Queries[$kv[0]] = $kv[1]
			}

			[Wallpaper]::SetWallpaper($OutputFile)
			# Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value $OutputFile
			# REG.exe ADD "HKCU\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d $OutputFile /f

			$WallpaperJson = "~/.wallpaper.json"
			@{ scheme=$ImgUri.Scheme; id=$ImgUri.Segments[1]; host=$ImgUri.Authority; query=$Queries } | ConvertTo-Json | Out-File -FilePath $WallpaperJson
		} finally {
			$Response.Dispose()
			Remove-Item -ErrorAction Ignore $OldFiles
		}
	}
	Start-Job -ScriptBlock $Src | Out-Null
}

## MS Teams のキャッシュを削除する
function Clear-MsTeamsCache {
	Stop-Process -ErrorAction Ignore -Name Teams
	Get-ChildItem -Path $Env:LocalAppData/Microsoft/Teams -Directory `
		| Where-Object Name -in ( 'blob_storage', 'Cache', 'databases', 'GPUCache', 'IndexedDB', 'Local Storage', 'tmp') `
		| ForEach-Object { Remove-Item -Force -Recurse $_ }
	Start-Process -FilePath $Env:LocalAppData/Microsoft/Teams/Update.exe -ArgumentList ('--processStart', 'Teams.exe')
}

## WSL2 向けに Large Send Offload を無効にする
# docker pull が高速化される(かも)
function Disable-WslNetAdapterLso {
	if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
		        [Security.Principal.WindowsBuiltInRole] "Administrator")) {
		Write-Warning "Administrator rights not found"
		return
	}
	Get-NetAdapterLso | Where-Object { $_.Name -like "vEthernet (WSL)" } | Disable-NetAdapterLso -IPv4 -IPv6 -PassThru
}
function Disable-WslNetAdapterLsoWithAdmin {
	Start-Process -Verb RunAs -FilePath "pwsh.exe" -ArgumentList "-c", "Disable-WslNetAdapterLso"
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

$CoreutilsBin = ("arch", "base32", "base64", "basename", "cat", "cksum", "comm", "cp",
		"cut", "date", "df", "dircolors", "dirname", "echo", "env", "expand",
		"expr", "factor", "false", "fmt", "fold", "hashsum", "head", "hostname",
		"join", "link", "ln", "md5sum", "mkdir", "mktemp", "more", "mv",
		"nl", "nproc", "od", "paste", "printenv", "printf", "ptx", "pwd",
		"readlink", "realpath", "relpath", "rm", "rmdir", "seq", "sha1sum",
		"sha224sum", "sha256sum", "sha3-224sum", "sha3-256sum", "sha3-384sum",
		"sha3-512sum", "sha384sum", "sha3sum", "sha512sum", "shake128sum",
		"shake256sum", "shred", "shuf", "split", "sum", "sync",
		"tac", "tail", "test", "touch", "tr", "true", "truncate",
		"tsort", "unexpand", "uniq", "wc", "whoami", "yes")
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

## broot
if (Test-Path -ErrorAction Stop -Path (Join-Path -Path $ScoopShimsDir -ChildPath 'broot.exe')) {
	# https://github.com/Canop/broot/issues/78#issuecomment-572631419
	function global:br {
		$OutCmd = New-Temporaryfile
		try {
			broot.exe --outcmd $OutCmd $args
			if (!$?) {
				Remove-Item -Force $OutCmd
				return $LastExitCode
			}

			$Command = Get-Content $OutCmd
			if ($Command) {
				# workaround - paths have some garbage at the start
				$Command = $Command.Replace("\\?\", "", 1)
				Invoke-Expression $Command
			}
		} finally {
			Remove-Item -Force $OutCmd
		}
	}
} else {
	Write-Output "broot not installed: scoop install broot"
}

## gsudo
try {
	Import-Module -ErrorAction SilentlyContinue "gsudoModule.psd1"
} catch {}
