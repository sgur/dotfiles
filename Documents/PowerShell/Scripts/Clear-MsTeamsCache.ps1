$TeamsProcess = Get-Process -ErrorAction Ignore -Name Teams
if ($TeamsProcess) {
	Stop-Process -ErrorAction Ignore -Name Teams
}

Get-ChildItem -Path $Env:LocalAppData/Microsoft/Teams -Directory `
	| Where-Object Name -in ( 'blob_storage', 'Cache', 'databases', 'GPUCache', 'IndexedDB', 'Local Storage', 'tmp') `
	| ForEach-Object { Remove-Item -Force -Recurse $_ }

if ($TeamsProcess) {
	Start-Process -FilePath $Env:LocalAppData/Microsoft/Teams/Update.exe -ArgumentList ('--processStart', 'Teams.exe')
}
