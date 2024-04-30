$VimLocation = Join-Path $Env:PROGRAMFILES "Vim" "vim91"
if (!(Test-Path -Path (Join-Path $VimLocation "gvim.exe"))) {
	Write-Host "Vim 9.1 not found. Exiting."
	Exit
}

$Shell = New-Object -ComObject WScript.Shell

$StartMenuLocation = Join-Path -Path $Env:APPDATA "Microsoft" "Windows" "Start Menu" "Programs" "Vim 9.1"
New-Item -ItemType Directory -Force -Path $StartMenuLocation

@(
[PSCustomObject]@{
	Name = "gVim Diff"
	Command = Join-Path $VimLocation "gvim.exe"
	Arguments = "-d"
	WorkingDir = '%USERPROFILE%'
},
[PSCustomObject]@{
	Name = "gVim Easy"
	Command = Join-Path $VimLocation "gvim.exe"
	Arguments = "-y"
	WorkingDir = '%USERPROFILE%'
},
[PSCustomObject]@{
	Name = "gVim Read-only"
	Command = Join-Path $VimLocation "gvim.exe"
	Arguments = "-R"
	WorkingDir = '%USERPROFILE%'
},
[PSCustomObject]@{
	Name = "gVim"
	Command = Join-Path $VimLocation "gvim.exe"
	Arguments = ""
	WorkingDir = '%USERPROFILE%'
},
[PSCustomObject]@{
	Name = "Help"
	Command = Join-Path $VimLocation "gvim.exe"
	Arguments = "-c h"
	WorkingDir = '%USERPROFILE%'
},
[PSCustomObject]@{
	Name = "Vim Diff"
	Command = Join-Path $VimLocation "vim.exe"
	Arguments = "-d"
	WorkingDir = '%USERPROFILE%'
},
[PSCustomObject]@{
	Name = "Vim Read-only"
	Command = Join-Path $VimLocation "vim.exe"
	Arguments = "-R"
	WorkingDir = '%USERPROFILE%'
},
[PSCustomObject]@{
	Name = "Vim"
	Command = Join-Path $VimLocation "vim.exe"
	Arguments = ""
	WorkingDir = '%USERPROFILE%'
}
) | ForEach-Object {
	$Path = Join-Path -Path $StartMenuLocation "$($_.Name).lnk"
	$Shortcut = $Shell.CreateShortcut($Path)
	$Shortcut.TargetPath = $_.Command
	$Shortcut.Arguments = $_.Arguments
	$Shortcut.IconLocation = Join-Path $Env:USERPROFILE ".vim" "bitmaps" "vim.ico"
	$Shortcut.WorkingDirectory = $_.WorkingDir
	$Shortcut.Save()
}

$SendToItemPath =[IO.Path]::Combine([Environment]::GetFolderPath([Environment+SpecialFolder]::SendTo), "gVim.lnk")
$Shortcut = $Shell.CreateShortcut($SendToItemPath)
$Shortcut.TargetPath = Join-Path $VimLocation "gvim.exe"
$Shortcut.Arguments = "--remote-tab-silent-wait"
$Shortcut.IconLocation = Join-Path $Env:USERPROFILE ".vim" "bitmaps" "vim.ico"
$Shortcut.WorkingDirectory = '%USERPROFILE%'
$Shortcut.Save()
