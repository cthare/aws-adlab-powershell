# Rename PC and set admin password
Rename-Computer -NewName 'adlab-dc01'
$passw = Get-SECSecretValue -SecretId ad-winlab -Select SecretString | ConvertFrom-Json | Select -ExpandProperty password
$UserAccount = Get-LocalUser -Name 'Administrator'
$UserAccount | Set-LocalUser -Password (convertto-securestring $passw -asplaintext -force)


# Install AD feature + management tools
Install-WindowsFeature AD-Domain-Services
Install-WindowsFeature RSAT-Role-Tools


# Setup post reboot task to setup AD
$taskAction = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument '-File C:\temp\general\setupAD.ps1'
$taskTrigger = New-ScheduledTaskTrigger -Once -At (get-date).addMinutes(10)
$taskName = 'Setup AD'
$description = 'Configured AD Domain'
Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description
$taskPrincipal = New-ScheduledTaskPrincipal -UserId 'Administrator' -RunLevel Highest
Set-ScheduledTask -TaskName 'Setup AD' -User $taskPrincipal.UserID -Password $passw


# Enable scheduled task logging
wevtutil set-log Microsoft-Windows-TaskScheduler/Operational /enabled:true

# Post install reboot
Restart-Computer -Force