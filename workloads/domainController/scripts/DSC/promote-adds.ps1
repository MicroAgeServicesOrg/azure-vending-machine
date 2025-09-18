Configuration CreateADReplicaDC 
{ 
   param 
    ( 
        [Parameter(Mandatory)][String]$DomainName,
        [Parameter(Mandatory)][System.Management.Automation.PSCredential]$safemodeAdminCreds,
        [Parameter(Mandatory)][System.Management.Automation.PSCredential]$Admincreds,
        [Parameter(Mandatory)][String]$adSiteName,

        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    )
    Import-DscResource -ModuleName  storageDsc, PSDesiredStateConfiguration, xDSCDomainJoin, ActiveDirectoryDsc, ComputerManagementDsc
    [System.Management.Automation.PSCredential]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)
    [System.Management.Automation.PSCredential]$SafeCreds = New-Object System.Management.Automation.PSCredential ($safemodeAdminCreds.UserName, $safemodeAdminCreds.Password)

    Node localhost
    {
       LocalConfigurationManager            
       {            
          ActionAfterReboot = 'ContinueConfiguration'            
          ConfigurationMode = 'ApplyOnly'            
          RebootNodeIfNeeded = $true            
       }

        WaitforDisk Disk1
        {
            DiskId = 1
            RetryIntervalSec =$RetryIntervalSec
            RetryCount = $RetryCount
        }

        Disk ADDataDisk {
            DiskId = 1
            DriveLetter = "F"
            DependsOn = "[WaitForDisk]Disk1"
        }

        xDSCDomainjoin JoinDomain
        {
            Domain = $DomainName
            Credential = $DomainCreds
            DependsOn = "[Disk]ADDataDisk"
		}
       WindowsFeature ADDSInstall 
       { 
          Ensure = "Present" 
          Name = "AD-Domain-Services"
          DependsOn = "[xDSCDomainJoin]JoinDomain"
       }
       WindowsFeature ADDSTools
       { 
          Ensure = "Present" 
          Name = "RSAT-ADDS-Tools"
          DependsOn = "[WindowsFeature]ADDSInstall"
       }

      ADDomainController ReplicaDC
      { 
         DomainName = $DomainName
         SiteName = $adSiteName
         Credential = $DomainCreds
         SafemodeAdministratorPassword = $SafeCreds
         DatabasePath = "F:\NTDS\Database"
         LogPath = "F:\NTDS\Logs"
         SysvolPath = "F:\SYSVOL"
         DependsOn = "[WindowsFeature]ADDSInstall"
      }

      PendingReboot Reboot1
      { 
         Name = "RebootServer"
         DependsOn = "[ADDomainController]ReplicaDC"
      }
   }
}