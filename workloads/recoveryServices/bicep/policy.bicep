targetScope= 'managementGroup'


param backupPolicy object


resource vmPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'backupPolicyDefinition'
  properties: {
    displayName: backupPolicy.properties.displayName
    description: backupPolicy.properties.description
    metadata: backupPolicy.properties.metadata
    policyRule: backupPolicy.properties.policyRule
    parameters: backupPolicy.properties.parameters
  }
}

output vaultPolicyDefinitionID string = vmPolicyDefinition.id
