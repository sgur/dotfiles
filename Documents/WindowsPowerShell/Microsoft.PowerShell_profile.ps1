# 文字化け対策
$OutputEncoding = [Text.UTF8Encoding]::UTF8
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
$Env:LC_ALL = "ja_JP.utf-8"

# $EDITOR を gVim にする
$Env:EDITOR = 'gvim --remote-tab-silent-wait'
## vscode のターミナル内のときのみ code -w
if ($Env:TERM_PROGRAM -eq 'vscode') {
	$Env:EDITOR = 'code -w'
}

## PSReadLine
$PSReadLineOptions = @{
	BellStyle = "Visual"
	EditMode = "Emacs"
	HistorySearchCursorMovesToEnd = $true
	HistoryNoDuplicates = $true
	PredictionSource = "History"
}
Set-PSReadLineOption @PSReadLineOptions

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+i -Function TabCompleteNext
Set-PSReadLineKeyHandler -Key Ctrl+Shift+i -Function TabCompletePrevious
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward

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
