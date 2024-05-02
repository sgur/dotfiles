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

[Environment]::SetEnvironmentVariable("WSLENV", $NewEnv, [EnvironmentVariableTarget]::Process)
[Environment]::SetEnvironmentVariable("WSLENV", $NewEnv.Replace("WT_SESSION:", "").Replace("WT_PROFILE_ID:", ""), [EnvironmentVariableTarget]::User)
