using './main.bicep'

param addsSubnetId = '/subscriptions/541b579a-8176-433f-a1b6-a6023b9b48bc/resourceGroups/masvcBicep-wus3-identity-rg/providers/Microsoft.Network/virtualNetworks/masvcBicepHubVnet/subnets/addsSubnet'
param location = 'westus3'
param dcPrefix = 'wus3tst'
param dcCount = 2
param zones = [
  1
  2
  3
]
param domainName = ''
param domainSiteName = ''
param domainAdminUsername = ''
param domainAdminPassword = ''
param safeModeUsername = ''
param safeModePassword = ''

