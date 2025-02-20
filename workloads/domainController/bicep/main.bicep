param addsSubnetId string = '/subscriptions/541b579a-8176-433f-a1b6-a6023b9b48bc/resourceGroups/masvcBicep-wus3-identity-rg/providers/Microsoft.Network/virtualNetworks/masvcBicepHubVnet/subnets/addsSubnet'
param location string = 'westus3'
param dcPrefix string = 'wus3'
@secure()
param adminPassword string
param dcCount int = 2 //number of VMs to deploy
param zones array = [
  1
  2
  3
]

param domainName string = 'masvc.local'
param domainSiteName string = 'Azure'
param domainAdminUsername string = 'domainjoin'
@secure()
param domainAdminPassword string

param safeModeUsername string = 'safemodeadmin'
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
    vmSize: 'Standard_D2ads_v5'
    zone: zones[i % length(zones)]
    location: location
    extensionDSCConfig: {
        enabled: true
        settings: {
          wmfVersion: 'latest'
          configuration: {
            url: 'https://masvcwus3dscconfig.blob.core.windows.net/scripts/promote-adds.zip'
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
