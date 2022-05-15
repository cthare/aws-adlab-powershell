# Rename PC and set admin password
Rename-Computer -NewName 'gen01'
$passw = convertto-securestring 'changeMe99!' -asplaintext -force
$UserAccount = Get-LocalUser -Name 'Administrator'
$UserAccount | Set-LocalUser -Password $passw

# Set DNS to domain controller
Set-DNSClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses "10.10.10.10"

# Reboot
Restart-Computer -Force