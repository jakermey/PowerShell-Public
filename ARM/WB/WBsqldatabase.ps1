param()

[string]$nowDate = Get-Date -UFormat
[String]$yearDate = Get-Date -Date ((Get-Date).AddYears(1)) -UFormat %s
$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['nbf'] = $nowDate
$DeploymentScriptOutputs['exp'] = $yearDate
