<# 
.SYNOPSIS
DSC config for Azure VMs with a Management Server role
Version: 0.0.1

.DESCRIPTION
DSC config voor:
- Services
---WinRM
-InstallFeature RSAT:
RSAT-Clustering IncludeAllSubFeature 
RSAT-Feature-Tools-BitLocker IncludeAllSubFeature
RSAT-AD-Tools  IncludeAllSubFeature
RSAT-Hyper-V-Tools IncludeAllSubFeature
RSAT-RDS-Tools IncludeAllSubFeature
RSAT-DHCP
RSAT-DNS-Server
RSAT-File-Services IncludeAllSubFeature
RSAT-Print-Services
Web-Mgmt-Tools IncludeAllSubFeature
GPMC


.NOTES
Multiple configurations


Author: (Alex den Nieuwenboer(OGD))
#>

configuration DSC_ManagementServer
{
	Import-DscResource –ModuleName PSDesiredStateConfiguration
	Import-DSCResource -ModuleName xPSDesiredStateConfiguration
	

	node localhost
	{

		###Remove SMBv1 and PSv2
		WindowsFeature RemoveSmb1
        {
            Ensure = "Absent"
            Name = "FS-SMB1"
        }

		WindowsFeature RemovePSv2
        {
            Ensure = "Absent"
            Name = "Powershell-V2"
        }

		###WinRM service check
		Service WinRM {
			Name = "WinRM"
			StartupType = "Automatic"
			State = "Running"
			Ensure = "Present"
		}

		###Admin Management features
		WindowsFeature RSAT-Clustering 
		{
			Name = "RSAT-Clustering"
			Ensure = "Present"
			IncludeAllSubFeature = $True
		}

		WindowsFeature RSAT-Feature-Tools-BitLocker
		{
			Name = "RSAT-Feature-Tools-BitLocker"
			Ensure = "Present"
			IncludeAllSubFeature = $True
		}

		WindowsFeature RSAT-AD-Tools
		{
			Name = "RSAT-AD-Tools"
			Ensure = "Present"
			IncludeAllSubFeature = $True
		}

		WindowsFeature RSAT-Hyper-V-Tools
		{
			Name = "RSAT-Hyper-V-Tools"
			Ensure = "Present"
			IncludeAllSubFeature = $True
		}

		WindowsFeature RSAT-RDS-Tools
		{
			Name = "RSAT-RDS-Tools"
			Ensure = "Present"
			IncludeAllSubFeature = $True
		}

		WindowsFeature RSAT-DHCP
		{
			Name = "RSAT-DHCP"
			Ensure = "Present"
		}

		WindowsFeature RSAT-DNS-Server
		{
			Name = "RSAT-DNS-Server"
			Ensure = "Present"
		}

		WindowsFeature RSAT-File-Services
		{
			Name = "RSAT-File-Services"
			Ensure = "Present"
			IncludeAllSubFeature = $True
		}

		WindowsFeature RSAT-Print-Services
		{
			Name = "RSAT-Print-Services"
			Ensure = "Present"
		}

		WindowsFeature Web-Mgmt-Tools
		{
			Name = "Web-Mgmt-Tools"
			Ensure = "Present"
			IncludeAllSubFeature = $True
		}

		WindowsFeature GroupPolicyManagement
		{
			Name = "GPMC"
			Ensure = "Present"
		}
	}

}
