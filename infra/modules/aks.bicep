@description('The location to deploy the resources')
param location string

@description('The name of the Workload Identity to create')
param workloadName string

@description('The name of the AKS cluster to create')
param aksName string

@description('The version of the AKS cluster to create')
param aksVersion string

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
output workloadPrincipalId string = workloadId.properties.principalId

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
    kubernetesVersion: aksVersion

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
        enableAutoScaling: false
        orchestratorVersion: aksVersion
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        workloadRuntime: 'OCIContainer'
        osSKU: 'AzureLinux'
        mode: 'System'
        count: 1
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
          'asm-1-20'
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

resource appPool 'Microsoft.ContainerService/managedClusters/agentPools@2024-01-02-preview' = {
  name: toLower('apppool')
  parent: aks
  properties: {
    enableAutoScaling: false
    orchestratorVersion: aksVersion
    vmSize: 'Standard_B2s_v2'
    osType: 'Linux'
    workloadRuntime: 'OCIContainer'
    osSKU: 'AzureLinux'
    mode: 'User'
    count: 1
    tags: tags
  }
}
