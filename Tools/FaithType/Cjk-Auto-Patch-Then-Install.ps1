#!/usr/bin/env pwsh

<#
	.SYNOPSIS
#>

param (
    [String]
    # Windows stock font directory.
    $StockFontsDir = 'C:\Windows\Fonts',

    [String]
    # Path to output files.
    $PatchedFontsDir = 'C:\Windows\Fonts\FaithType',

    [String]
    $_Private0 = '',
    [String]
    $_Private1 = ''
)

Set-StrictMode -Version 3.0

if ($_Private0 -eq '') {

    $_Private0 = (Get-Location).Path
    $_Private1 = if ($null -ne $Env:CARGO -and $Env:CARGO -ne '') {
        $Env:CARGO
    } else {
        ''
    }
    Start-Process -FilePath 'powershell.exe' -ArgumentList (
        '-ExecutionPolicy', 'Bypass', '-NoLogo', '-NoProfile', '-File', """$($PSCommandPath.replace('"', '\"'))""", '-StockFontsDir', """$($StockFontsDir.replace('"', '\"'))""", '-PatchedFontsDir', """$($PatchedFontsDir.replace('"', '\"'))""", '-_Private0', """$($_Private0.replace('"', '\"'))""", '-_Private1', """$($_Private1.replace('"', '\"'))"""
    ) -Verb 'RunAs' -ErrorAction Stop | Out-Null

} else {

    try {
# spell-checker: disable
        $FilesToPatch = (
            # Batang (Korean)
            'batang.ttc',
			# BIZ UDP Gothic (Japanese)
			'BIZ-UDGothicB.ttc',
			'BIZ-UDGothicR.ttc',
			'BIZ-UDMinchoM.ttc',
            # DengXian (Simplified Chinese)
            'Dengb.ttf',
            'Dengl.ttf',
            'Deng.ttf',
            # Gulim (Korean)
            'gulim.ttc',
            # Malgun Gothic (Korean)
            'malgunbd.ttf',
            'malgunsl.ttf',
            'malgun.ttf',
            # Meiryo (Japanese)
            'meiryob.ttc',
            'meiryo.ttc',
            # MingLiU (Traditional Chinese)
            'mingliub.ttc',
            'mingliu.ttc',
            # MS Gothic (Japanese)
            'msgothic.ttc',
            # Microsoft JhengHei (Traditional Chinese)
            'msjhbd.ttc',
            'msjhl.ttc',
            'msjh.ttc',
            # MS Mincho (Japanese)
            'msmincho.ttc',
            # Microsoft YaHei (Simplified Chinese)
            'msyhbd.ttc',
            'msyhl.ttc',
            'msyh.ttc',
            # Segoe MDL2 Assets (Symbols)
            'segmdl2.ttf',
            # Segoe UI Symbol (Symbols)
            'seguisym.ttf',
            # FangSong (Simplified Chinese)
            'simfang.ttf',
            # SimHei (Simpified Chinese)
            'simhei.ttf',
            # KaiTi (Simplified Chinese)
            'simkai.ttf',
            # SimSun (Simplified Chinese)
            'simsunb.ttf',
            'simsun.ttc',
            # Symbol (Symbols)
            'symbol.ttf',
			# UD Digital Kyokasho (Japanese)
			'UDDigiKyokashoN-B.ttc',
			'UDDigiKyokashoN-R.ttc',
            # Webdings (Symbols)
            'webdings.ttf',
            # Wingdings (Symbols)
            'wingding.ttf',
            # Yu Gothic (Japanese)
            'YuGothB.ttc',
            'YuGothL.ttc',
            'YuGothM.ttc',
            'YuGothR.ttc',
            # Yu Mincho (Japanese)
            'yumindb.ttf',
            'yuminl.ttf',
            'yumin.ttf'
        )
# spell-checker: enable

        Set-Location -LiteralPath $_Private0 -ErrorAction Stop
        if ($_Private1 -ne '') {
            $Env:CARGO = $_Private1
        }
        $InputPaths = $FilesToPatch | ForEach-Object {
            Join-Path -Path $StockFontsDir -ChildPath $_ -ErrorAction Stop
        } | Where-Object {
            Test-Path $_ -PathType Leaf -ErrorAction Stop
        }
        . $PSScriptRoot\Manual-Batch-Patch.ps1 -OutputDir $PatchedFontsDir -InputFiles $InputPaths
        . $PSScriptRoot\Manual-Install-Registry.ps1 -PatchedFontsDir $PatchedFontsDir
    } catch {
        Write-Error -Exception $_.Exception
    }

    Write-Output ""
    Read-Host 'Press Enter to exit'
}
