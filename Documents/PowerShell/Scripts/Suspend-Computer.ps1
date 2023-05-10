$Signature = @"
[DllImport("powrprof.dll")]
public static extern bool SetSuspendState(bool Hibernate, bool ForceCritical, bool DisableWakeEvent;
"@
$func = Add-Type -MemberDefinition $Signature -Namespace "Win32Functions" -Name "SetSuspendStateFunction" -PassThru
$func::SetSuspendState($false, $false, $true)
