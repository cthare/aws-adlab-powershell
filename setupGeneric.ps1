# Rename PC and set admin password
Rename-Computer -NewName 'gen01'
$passw = convertto-securestring 'changeMe99!' -asplaintext -force
$UserAccount = Get-LocalUser -Name 'Administrator'
$UserAccount | Set-LocalUser -Password $passw

# Setup post reboot task to setup AD
$taskAction = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument '-File C:\temp\postSetupGeneric.ps1'
$taskTrigger = New-ScheduledTaskTrigger -Once -At (get-date).addMinutes(20)
$taskName = 'Join to Domain'
$description = 'Sets DNS and joins to domain'
Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description
$taskPrincipal = New-ScheduledTaskPrincipal -UserId 'Administrator' -RunLevel Highest
Set-ScheduledTask -TaskName 'Join to Domain' -User $taskPrincipal.UserID -Password 'changeMe99!'

# Reboot
Restart-Computer -Force