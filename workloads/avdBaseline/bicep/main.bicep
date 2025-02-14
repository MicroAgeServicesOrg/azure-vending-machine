targetScope = 'subscription'

param location string

param clientCode string


@sys.description('Do not modify, used to set unique value for resource deployment.')
param time string = utcNow()








//variables

var varServiceObjectsRgName = '${clientCode}-${location}-avd-service-objects-rg'
var varComputeObjectsRgName = '${clientCode}-${location}-avd-compute-rg'
var varNetworkRGName = '${clientCode}-${location}-avd-network-rg'
var varStorageRgName = '${clientCode}-${location}-avd-storage-rg'

var baselineResourceGroups = [
  {
    name: varNetworkRGName
    location: location
    purpose: 'Network-Resources'
  }
  {
      name: varServiceObjectsRgName
      location: location
      purpose: 'AVD-Service-Objects'
  }
  {
      name: varComputeObjectsRgName
      location: location
      purpose: 'AVD-Compute-Objects'
  }
  {
    name: varStorageRgName
    location: location
    purpose: 'AVD-Storage-Objects'
}
]



module baselineRGs 'br/public:avm/res/resources/resource-group:0.2.3' = [for resourceGroup in baselineResourceGroups: {
  name: 'deployBaselineRGs-${time}'
  params: {
    name: resourceGroup.name
    location: resourceGroup.location
  }

}]
