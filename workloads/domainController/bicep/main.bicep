param addsSubnetId string
param location string
param vmSKU string
param dcPrefix string
@secure()
param adminPassword string
param dcCount int = 2 //number of VMs to deploy
param useAvailabilityZones bool
param zones array = [
  1
  2
  3
]

param domainName string
param domainSiteName string
param domainAdminUsername string
@secure()
param domainAdminPassword string
param safeModeUsername string
@secure()
param safeModePassword string


module domainController1 'br/public:avm/res/compute/virtual-machine:0.12.0' = [ for i in range(0, dcCount): {
  name: '${uniqueString(deployment().name, location)}-ADDC-${i}' //the name of the modules deployment
  params: {
    name: '${dcPrefix}-dc${i + 1}'
    adminUsername: 'azadmin'
    adminPassword: adminPassword
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: addsSubnetId
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      caching: 'ReadOnly'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    dataDisks: [
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        diskSizeGB: 20
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        lun: 0
      }
    ]
    osType: 'Windows'
    vmSize: vmSKU
    zone: useAvailabilityZones ? zones[i % length(zones)] : null
    location: location
    extensionDSCConfig: {
        enabled: true
        settings: {
          wmfVersion: 'latest'
          configuration: {
            url: 'https://github.com/MicroAgeServicesOrg/azure-vending-machine/raw/refs/heads/main/workloads/domainController/scripts/DSC/promote-adds.zip'
            script: 'promote-adds.ps1'
            function: 'CreateADReplicaDC'
          }
          configurationArguments: {
            DomainName: domainName
            adSiteName: domainSiteName
          }
        }
          protectedSettings: {
            configurationArguments: {
              Admincreds: {
                UserName: domainAdminUsername
                Password: domainAdminPassword
              }
              safemodeAdminCreds: {
                UserName: safeModeUsername
                Password: safeModePassword
              }
            }
          }
      }
    }
}
]
