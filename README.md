# Get-msDSSupportedEncryptionTypes

Run with ". Get-msDSSupportedEncryptionTypes.ps1" or ". Get-msDSSupportedEncryptionTypes.ps1 DomainControllerName"

A domain controller name can be specified, credentials will be requested, although may not be necessary. If the script is run from a non-domian computer, a domain controller must be specified and the credential request requires a user name formatted as domainname\username or username@domain with a password.

The output displays all computer accounts with RC4 as a supported Kerberos encryption type, the output is saved in C:\Temp (make sure such a directory exists or specify something different).
