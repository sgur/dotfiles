$NewEnv = $ENV:WSLENV
# WSLENV に "USERPROFILE" が含まれているかチェックする
if ($ENV:WSLENV -notlike "*USERPROFILE*") {
	# OneDrive が含まれていない場合は追加する
	$NewEnv += 'USERPROFILE/p:'
}

# WSLENV に "OneDrive" が含まれているかチェックする
if ($ENV:WSLENV -notlike "*OneDrive*") {
	# OneDrive が含まれていない場合は追加する
	$NewEnv += 'OneDrive/p:'
}

# WSLENV に CHEZMOI_GITHUB_ACCESS_TOKEN が含まれているかチェック
if ($ENV:WSLENV -notlike "*CHEZMOI_GITHUB_ACCESS_TOKEN*") {
	# OneDrive が含まれていない場合は追加する
	$NewEnv += 'CHEZMOI_GITHUB_ACCESS_TOKEN:'
}

[Environment]::SetEnvironmentVariable("WSLENV", $NewEnv, [EnvironmentVariableTarget]::Process)
[Environment]::SetEnvironmentVariable("WSLENV", $NewEnv.Replace("WT_SESSION:", "").Replace("WT_PROFILE_ID:", ""), [EnvironmentVariableTarget]::User)
