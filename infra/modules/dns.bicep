@description('Name of the DNS zone to be deployed.')
param publicDnsZoneName string

@description('Tags to be assigned to the DNS zone.')
param tags object

@description('The workload id to be assigned as KeyVault Secret User role.')
param workloadPrincipleId string

resource publicDnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' = {
  name: publicDnsZoneName
  tags: tags
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}

@description('This is the built-in "DNS Zone Contributor" role. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/networking#dns-zone-contributor')
resource publicDnsContributorRd 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'befefa01-2a29-4197-83a8-272ff33ce314'
}

@description('Grant the workload the "DNS Zone Contributor" role on the DNS zone.')
resource publicDnsContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: publicDnsZone
  name: guid(resourceGroup().id, workloadPrincipleId, publicDnsContributorRd.id)
  properties: {
    roleDefinitionId: publicDnsContributorRd.id
    principalId: workloadPrincipleId
    principalType: 'ServicePrincipal'
  }
}
