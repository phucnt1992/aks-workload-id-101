resource dnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' = {
  name: 'persona.store'
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}
