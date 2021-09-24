param()
                    
[String]$output = Get-Date -Date ((Get-Date).AddYears(1)) -UFormat %s
$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['expireDate'] = $output