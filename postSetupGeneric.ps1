# Set DNS to domain controller
Set-DNSClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses "10.10.10.10"

# Join to Domain
$passw = ConvertTo-SecureString "changeMe99!" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential("adlab\Administrator",$passw)
Add-Computer -DomainName "adlab.local" -Credential $cred

# Reboot
Restart-Computer -Force