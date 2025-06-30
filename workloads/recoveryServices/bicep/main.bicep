targetScope = 'managementGroup'
param subscriptionID string
param backupRGName string
param location string = 'westus3'
param vaultName string

param assignmentMgmtGroupID string

param backupPolicy object = loadJsonContent('../policy/rsvPolicy_current.json')



module vault 'vault.bicep' = {
  scope: subscription(subscriptionID)
  params: {
    location: location
    backupRGName: backupRGName
    vaultName: vaultName
  }
}

module azurePolicy 'policy.bicep' = {
  params: {
    backupPolicy: backupPolicy
  }
}

module azurePolicyAssugnment 'policyAssignment.bicep' = {
  scope: managementGroup(assignmentMgmtGroupID)
  params: {
    location: location
    vaultID: vault.outputs.vaultId
    vmPolicyDefinitionID: azurePolicy.outputs.vaultPolicyDefinitionID
  }
}
