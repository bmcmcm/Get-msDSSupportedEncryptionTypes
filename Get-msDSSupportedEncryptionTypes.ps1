[CmdletBinding()]
param(
	[Parameter(Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
	[Alias("CN","DC","DomainController")]
	[String]$server=("$env:LOGONSERVER").Trim("\\"),
	[Parameter(Position=1,ValueFromPipeline=$false,ValueFromPipelineByPropertyName=$false)]
	[Alias("Output","File")]
	[String]$ExportPath="C:\Temp"	
	)

$cred = Get-Credential

[Flags()] enum SupportedEncryptionTypes
{
    Not_defined_defaults_to_RC4_HMAC_MD5                  =0
    DES_CBC_CRC                                           =1
    DES_CBC_MD5                                           =2
    DES_CBC_CRC__DES_CBC_MD5                              =3
    RC4                                                   =4
    DES_CBC_CRC__RC4                                      =5
    DES_CBC_MD5__RC4                                      =6
    DES_CBC_CRC__DES_CBC_MD5__RC4                         =7
    AES_128                                               =8
    DES_CBC_CRC__AES_128                                  =9
    DES_CBC_MD5__AES_128                                  =10
    DES_CBC_CRC__DES_CBC_MD5__AES_128                     =11
    RC4__AES_128                                          =12
    DES_CBC_CRC__RC4__AES_128                             =13
    DES_CBC_MD5__RC4__AES_128                             =14
    DES_CBC_CBC__DES_CBC_MD5__RC4__AES_128                =15
    AES_256                                               =16
    DES_CBC_CRC__AES_256                                  =17
    DES_CBC_MD5__AES_256                                  =18
    DES_CBC_CRC__DES_CBC_MD5__AES_256                     =19
    RC4__AES_256                                          =20
    DES_CBC_CRC__RC4__AES_256                             =21
    DES_CBC_MD5__RC4__AES_256                             =22
    DES_CBC_CRC__DES_CBC_MD5__RC4__AES_256                =23
    AES_128__AES_256                                      =24
    DES_CBC_CRC__AES_128__AES_256                         =25
    DES_CBC_MD5__AES_128__AES_256                         =26
    DES_CBC_MD5__DES_CBC_MD5__AES_128__AES_256            =27
    RC4__AES_128__AES_256                                 =28
    DES_CBC_CRC__RC4__AES_128__AES_256                    =29
    DES_CBC_MD5__RC4__AES_128__AES_256                    =30
    DES_A1_C33_CBC_MD5__DES_CBC_MD5__RC4__AES_128__AES_256=31
}

$GetUserParams = @{
    LDAPFilter = '(!(userAccountControl:1.2.840.113556.1.4.803:=2))'
    Properties = 'name','msDS-SupportedEncryptionTypes','operatingSystem'
    Server = $server
    Credential = $cred
}
$ComputerInfo = Get-ADComputer @GetUserParams | Select-Object -Property @(
    'Name'
    'OperatingSystem'
    @{Name = 'SupportedEncryptionTypes'; Expression={[SupportedEncryptionTypes]($_."msDS-SupportedEncryptionTypes") }}
) 

$ComputerInfo | Where-Object {$_.SupportedEncryptionTypes -match "RC4" -or $_.SupportedEncryptionTypes -eq $null} | Sort-Object "OperatingSystem" | Out-GridView
$ComputerInfo | Export-Csv -Path $ExportPath -NoTypeInformation
