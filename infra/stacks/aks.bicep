param lo

resource workloadId 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  location: resourceGroup().location
  name: name
  tags: {}
}

resource aks 'Microsoft.ContainerService/managedClusters@2024-01-02-preview' = {
  location: 'test'
  name: 'test'

  enableRBAC: true
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${workloadId.id}': {}
    }
  }
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  properties: {
    // Enable OIDC Issuer
    oidcIssuerProfile: {
      enabled: true
    }
    agentPoolProfiles: [
      {
        name: toLower()
      }
    ]
    addonProfiles: {
      azureKeyvaultSecretsProvider: {
        enabled: true
        config: {
          enableSecretRotation: true
          rotationPollInterval: '2m'
        }
      }
      serviceMeshProfile: {
        mode: 'Istio'
        istio: {
          components: {
            ingressGateways: [
              {
                enabled: true
                mode: 'External'
              }
            ]
          }
        }
      }
    }
  }
}
