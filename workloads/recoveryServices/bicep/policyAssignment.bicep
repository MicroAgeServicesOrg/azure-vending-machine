targetScope = 'managementGroup'
param location string
param vmPolicyDefinitionID string
param vaultID string

var vaultPolicyID = '${vaultID}/backupPolicies/vmDefaultPolicy'

resource vmPolicyAssignment 'Microsoft.Authorization/policyAssignments@2025-01-01' = {
  name: 'backupPolicyAssignment'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    policyDefinitionId: vmPolicyDefinitionID
    displayName: 'vmBackupPolicyAssignment'
    parameters: {
      vaultLocation: {
        value: location
      }
      backupPolicyId: {
        value: vaultPolicyID
      }
    }
  }
}

@description('This is the built-in Contributor role. See https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource vmContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
}

@description('This is the built-in Contributor role. See https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource backupContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '5e467623-bb1f-42f4-a55d-6e525e11384b'
}


resource roleAssignmentVmContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managementGroup().id, vmPolicyAssignment.name, vmContributorRoleDefinition.id)
  properties: {
    principalId: vmPolicyAssignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  }
}
resource roleAssignmentBackupContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managementGroup().id, vmPolicyAssignment.name, backupContributorRoleDefinition.id)
  properties: {
    principalId: vmPolicyAssignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/5e467623-bb1f-42f4-a55d-6e525e11384b'
  }
}
