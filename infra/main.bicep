targetScope = 'subscription'

param location string = 'southeastasia'

param tags object = {
  environment: 'dev'
  costCenter: 'it'
  bicep: true
}

resource secretRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-secret-dev-sea-01'
  location: location
  tags: tags
}

resource aksRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-aks-dev-sea-01'
  location: location
  tags: tags
}

module secretModule 'stacks/secret.bicep' = {
  name: 'secretModule'
  scope: secretRg
  params: {
    name: 'kv-launchpad-dev-sea-01'
    location: location
    tags: tags
  }
}

module aksModule 'stacks/aks.bicep' = {
  name: 'aksModule'
  scope: aksRg
  params: {
    aksName: 'aks-launchpad-dev-sea-01'
    workloadName: 'id-aks-dev-sea-01'
    location: location
    tags: tags
    nodeRg: 'rg-aksnodes-dev-sea-01'
  }
}
