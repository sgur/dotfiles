# https://stackoverflow.com/a/20588680

$Colors = [Enum]::GetValues( [ConsoleColor] )
$Max = ($Colors | ForEach-Object { "$_ ".Length } | Measure-Object -Maximum).Maximum
foreach( $Color in $Colors ) {
	Write-Host (" {0,2} {1,$Max} " -f [int]$color,$color) -NoNewline
	Write-Host "  " -Background $color -NoNewline
	Write-Host " " -NoNewline
	Write-Host "$Color" -Foreground $color
}
