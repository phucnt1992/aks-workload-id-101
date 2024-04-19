@description('Name of the DNS zone to be deployed.')
param publicDnsZoneName string

@description('Tags to be assigned to the DNS zone.')
param tags object

resource publicDnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' = {
  name: publicDnsZoneName
  tags: tags
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}
