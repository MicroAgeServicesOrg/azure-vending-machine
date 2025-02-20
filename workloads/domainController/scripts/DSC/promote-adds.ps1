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

        WaitforDisk Disk2
        {
            DiskId = 2
            RetryIntervalSec =$RetryIntervalSec
            RetryCount = $RetryCount
        }

        Disk ADDataDisk {
            DiskId = 2
            DriveLetter = "F"
            DependsOn = "[WaitForDisk]Disk2"
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

       WaitForADDomain DscForestWait
       { 
          DomainName = $DomainName 
          Credential= $DomainCreds
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
         DependsOn = "[WaitForADDomain]DscForestWait"
      }

      PendingReboot Reboot1
      { 
         Name = "RebootServer"
         DependsOn = "[ADDomainController]ReplicaDC"
      }
   }
}