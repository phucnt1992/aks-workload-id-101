@description('The location to deploy the resources')
param location string

@description('The name of the Workload Identity to create')
param workloadName string

@description('The name of the AKS cluster to create')
param aksName string

@description('The name of the resource group to create the AKS Node VMs in')
param nodeRg string

@description('The tags to apply to the resources')
param tags object

@description('The tags to apply to the resources')
resource workloadId 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  location: location
  name: workloadName
  tags: tags
}
output workloadId string = workloadId.id

resource aks 'Microsoft.ContainerService/managedClusters@2024-01-02-preview' = {
  location: location
  name: aksName
  tags: tags
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    nodeResourceGroup: nodeRg

    // Enable OIDC Issuer
    oidcIssuerProfile: {
      enabled: true
    }
    // Enable Workload Identity
    securityProfile: {
      workloadIdentity: {
        enabled: true
      }
    }
    dnsPrefix: aksName
    agentPoolProfiles: [
      {
        name: toLower('systempool')
        enableAutoScaling: true
        orchestratorVersion: '1.29.2'
        vmSize: 'Standard_DS4_v2'
        osType: 'Linux'
        workloadRuntime: 'OCIContainer'
        osSKU: 'AzureLinux'
        mode: 'System'
        count: 1
        minCount: 1
        maxCount: 2
        tags: tags
      }
      {
        name: toLower('apppool')
        enableAutoScaling: true
        orchestratorVersion: '1.29.2'
        vmSize: 'Standard_B2s_v2'
        osType: 'Linux'
        workloadRuntime: 'OCIContainer'
        osSKU: 'AzureLinux'
        mode: 'User'
        count: 1
        minCount: 1
        maxCount: 2
        tags: tags
      }
    ]
    serviceMeshProfile: {
      mode: 'Istio'
      istio: {
        components: {
          egressGateways: [
            {
              enabled: false
            }
          ]
          ingressGateways: [
            {
              enabled: true
              mode: 'External'
            }
          ]
        }
        revisions: [
          'string'
        ]
      }
    }
    addonProfiles: {
      azureKeyvaultSecretsProvider: {
        enabled: true
        config: {
          enableSecretRotation: 'true'
          rotationPollInterval: '2m'
        }
      }
    }
  }
}
output aksId string = aks.id
