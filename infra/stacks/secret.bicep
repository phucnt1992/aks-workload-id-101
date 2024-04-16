@description('The keyvault name to be deployed.')
param name string

@description('The location will be deployed.')
param location string = resourceGroup().location

@description('The tag to.')
param tags object

resource launchpad 'Microsoft.KeyVault/vaults@2023-07-01' = {
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
output launchpad string = launchpad.id
