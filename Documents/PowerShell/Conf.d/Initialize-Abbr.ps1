# https://zenn.dev/yukimemi/articles/2026-01-18-powershell-abbr

# --- Abbreviation Expansion ---
$abbrs = @{
	".."  = "cd .."
	"chz" = "chezmoi"
	"chz-cd" = "Set-Location (chezmoi source-path)"
}

$expandAbbrLogic = {
	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

	if ($cursor -gt 0)
	{
		$sub = $line.Substring(0, $cursor)
		if ($sub -match '(?<Word>\S+)$')
		{
			$word = $Matches['Word']
			if ($abbrs.ContainsKey($word))
			{
				[Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - $word.Length, $word.Length)
					[Microsoft.PowerShell.PSConsoleReadLine]::Insert($abbrs[$word])
			}
		}
	}
}

Set-PSReadLineKeyHandler -Key Spacebar -ScriptBlock {
	. $expandAbbrLogic
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert(' ')
}.GetNewClosure()

Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
	. $expandAbbrLogic
	[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}.GetNewClosure()
