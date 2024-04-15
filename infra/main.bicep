targetScope = 'subscription'

param location string = 'southeastasia'

resource secretRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-secret-dev-sea-01'
  location: location
}

module secretModule 'stacks/secret.bicep' = {
  name: 'secretModule'
  scope: secretRg
  params: {
    name: 'kv-secret-dev-sea-01'
  }
}
