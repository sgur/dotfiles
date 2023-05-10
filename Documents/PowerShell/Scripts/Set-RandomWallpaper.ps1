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
	Remove-Item -ErrorAction SilentlyContinue $OldFiles
}

