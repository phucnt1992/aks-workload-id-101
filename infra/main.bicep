targetScope = 'subscription'

param location string = 'southeastasia'
param publicDnsZoneName string

param tags object = {
  environment: 'dev'
  costCenter: 'it'
  bicep: 'true'
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

resource networkRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-network-dev-sea-01'
  location: location
  tags: tags
}

module aksModule 'modules/aks.bicep' = {
  name: 'aksModule'
  scope: aksRg
  params: {
    aksName: 'aks-app-dev-sea-01'
    acrName: 'acrappdevsea01'
    workloadName: 'id-aks-dev-sea-01'
    nodeRg: 'rg-aksnodes-dev-sea-01'
    aksVersion: '1.29.2'
    location: location
    tags: tags
  }
}

module secretModule 'modules/secret.bicep' = {
  name: 'secretModule'
  scope: secretRg
  params: {
    name: 'kv-launchpad-dev-sea-02'
    location: location
    workloadPrincipleId: aksModule.outputs.workloadPrincipalId
    tags: tags
  }
}

module dnsModule 'modules/dns.bicep' = {
  name: 'dnsModule'
  scope: networkRg
  params: {
    publicDnsZoneName: publicDnsZoneName
    workloadPrincipleId: aksModule.outputs.workloadPrincipalId
    tags: tags
  }
}
