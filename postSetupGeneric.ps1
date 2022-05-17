# Set DNS to domain controller
Set-DNSClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses "10.10.10.10"

# Join to Domain
$passw = Get-SECSecretValue -SecretId ad-winlab -Select SecretString | ConvertFrom-Json | Select -ExpandProperty password
$cred = New-Object System.Management.Automation.PSCredential("adlab\Administrator",(convertto-securestring $passw -asplaintext -force))
Add-Computer -DomainName "adlab.local" -Credential $cred

# Reboot
Restart-Computer -Force