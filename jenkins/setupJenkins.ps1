# Rename PC and set admin password
Rename-Computer -NewName 'jenkins-windows'
$passw = Get-SECSecretValue -SecretId ad-winlab -Select SecretString | ConvertFrom-Json | Select -ExpandProperty password
$UserAccount = Get-LocalUser -Name 'Administrator'
$UserAccount | Set-LocalUser -Password (convertto-securestring $passw -asplaintext -force)

# Setup post reboot task to setup AD
$taskAction = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument '-File C:\temp\jenkins\postSetupJenkins.ps1'
$taskTrigger = New-ScheduledTaskTrigger -Once -At (get-date).addMinutes(20)
$taskName = 'Join to Domain'
$description = 'Sets DNS and joins to domain'
Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description
$taskPrincipal = New-ScheduledTaskPrincipal -UserId 'Administrator' -RunLevel Highest
Set-ScheduledTask -TaskName 'Join to Domain' -User $taskPrincipal.UserID -Password $passw

# Reboot
Restart-Computer -Force