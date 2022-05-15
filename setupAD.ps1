# Domain Setup
$passw = convertto-securestring 'changeMe99!' -asplaintext -force

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
    -SafeModeAdministratorPassword $passw -Force:$true
}
catch {
    'Failed' | Out-File -FilePath C:\temp\domainLog.txt
}


# Flag for when install and setup is complete
'Done' | Out-File -FilePath C:\temp\completed.txt

Restart-Computer -Force