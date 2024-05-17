param peNamePrefix string
param subnetId string
param privateDnsZoneId string
param storageAccountResourceIdPrefix string
param startIndex int
param peCount int

resource privateEndpoints 'Microsoft.Network/privateEndpoints@2023-09-01' = [for i in range(startIndex,peCount): {
  name: '${peNamePrefix}${i}'
  location: resourceGroup().location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${peNamePrefix}${i}'
        properties: {
          privateLinkServiceId: '${storageAccountResourceIdPrefix}${i}'
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}]

resource pvtEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = [for i in range(startIndex,peCount): {
  name: '${peNamePrefix}${i}/dnsgroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints[i-startIndex]
  ]
}]
