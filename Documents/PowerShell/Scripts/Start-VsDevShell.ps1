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
