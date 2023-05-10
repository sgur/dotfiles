#Requires -RunAsAdministrator

# if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
#			[Security.Principal.WindowsBuiltInRole] "Administrator")) {
#	Write-Warning "Administrator rights not found"
#	return
# }

Get-NetAdapterLso | Where-Object { $_.Name -like "vEthernet (WSL)" } | Disable-NetAdapterLso -IPv4 -IPv6 -PassThru
