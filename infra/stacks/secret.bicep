@description('The keyvault name to be deployed.')
param name string

@description('The location will be deployed.')
param location string

resource secretMgnt 'Microsoft.KeyVault/vaults@2023-07-01' = {
  location: location
  name: name

  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
  }
}
