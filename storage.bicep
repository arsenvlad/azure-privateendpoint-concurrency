param location string = resourceGroup().location
@minLength(5)
param storageAccountPrefix string
param storageAccountCount int = 1

@batchSize(10)
resource storageAccounts 'Microsoft.Storage/storageAccounts@2023-04-01' = [for i in range(1, storageAccountCount) : {
  name: '${storageAccountPrefix}${i}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowSharedKeyAccess: false
  }
}]
