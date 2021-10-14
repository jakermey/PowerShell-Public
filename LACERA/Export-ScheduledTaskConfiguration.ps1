Param(
    $TaskName = ''
)

Get-ScheduledTask -TaskName $TaskName | Format-List * | Out-File $ENV:ProgramData/ScheduledTask.log
Get-ScheduledTask -TaskName $TaskName | Select-Object -ExpandProperty CimInstanceProperties | Format-List * | Out-File $ENV:ProgramData/ScheduledTaskProperties.log
Get-ScheduledTask -TaskName $TaskName | Select-Object -ExpandProperty Triggers -Verbose | Format-List * | Out-File $ENV:ProgramData/ScheduledTaskTriggers.log
Get-ScheduledTask -TaskName $TaskName | Select-Object -ExpandProperty Triggers | Select-Object -ExpandProperty CimInstanceProperties -Verbose | Format-List * | Out-File $ENV:ProgramData/ScheduledTaskTriggersProperties.log
Get-ScheduledTask -TaskName $TaskName | Select-Object -ExpandProperty Actions | Format-List * | Out-File $ENV:ProgramData/ScheduledTaskActions.log
Get-ScheduledTask -TaskName $TaskName | Select-Object -ExpandProperty Actions | Select-Object -ExpandProperty CimInstanceProperties | Format-List * | Out-File $ENV:ProgramData/ScheduledTaskActions.log
Get-ScheduledTask -TaskName $TaskName | Select-Object -ExpandProperty Actions | Select-Object -ExpandProperty CimInstanceProperties | Format-List * | Out-File $ENV:ProgramData/ScheduledTaskActionsProperties.log
Get-ScheduledTask -TaskName $TaskName | Select-Object -ExpandProperty Actions | Select-Object -ExpandProperty CimInstanceProperties | Format-List * | Out-File $ENV:ProgramData/ScheduledTaskActionsProperties.log