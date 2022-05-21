# Domain Setup
$passw = Get-SECSecretValue -SecretId ad-winlab -Select SecretString | ConvertFrom-Json | Select -ExpandProperty password

try {
Install-ADDSForest -CreateDnsDelegation:$false `
    -DatabasePath 'C:\Windows\NTDS' `
    -DomainMode 'WinThreshold' `
    -DomainName 'adlab.local' `
    -DomainNetbiosName 'ADLAB' `
    -ForestMode 'WinThreshold' `
    -InstallDns:$true `
    -LogPath 'C:\Windows\NTDS' `
    -NoRebootOnCompletion:$false `
    -SysvolPath 'C:\Windows\SYSVOL' `
    -SafeModeAdministratorPassword (convertto-securestring $passw -asplaintext -force) -Force:$true
}
catch {
    'Failed' | Out-File -FilePath C:\temp\domainLog.txt
}


# Flag for when install and setup is complete
'Done' | Out-File -FilePath C:\temp\completed.txt

Restart-Computer -Force