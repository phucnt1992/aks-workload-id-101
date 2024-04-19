@description('The keyvault name to be deployed.')
param name string

@description('The location will be deployed.')
param location string

@description('The workload id to be assigned as KeyVault Secret User role.')
param workloadPrincipleId string

@description('The tag to.')
param tags object

resource secretVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  location: location
  name: name
  tags: tags

  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    enableSoftDelete: true
    enableRbacAuthorization: true
  }
}
output keyVaultName string = secretVault.name

@description('This is the built-in "Key Vault Secret User" role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#key-vault-secrets-user')
resource kvSecretUserRd 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '4633458b-17de-408a-b874-0445c86b69e6'
}

@description('Grant the app service identity with key vault secret user role permissions over the key vault. This allows reading secret contents')
resource keyVaultSecretUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: secretVault
  name: guid(resourceGroup().id, workloadPrincipleId, kvSecretUserRd.id)
  properties: {
    roleDefinitionId: kvSecretUserRd.id
    principalId: workloadPrincipleId
    principalType: 'ServicePrincipal'
  }
}
