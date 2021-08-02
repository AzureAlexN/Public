[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$domainName,

    [Parameter(Mandatory = $false)]
    [securestring]$safepass
)
# Install ADDS Windows Feature
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Install ADDSForest
Install-ADDSForest -DomainName $domainName -InstallDns:$true -NoRebootCompletion:$true -SafeModeAdministratorPassword $safepass

Restart-Computer