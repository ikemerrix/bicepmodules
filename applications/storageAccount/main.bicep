param location string
param storageName string

module storage '../../bicepmodules/storageAccounts/storage.bicep' = {
  name: 'storageDeploy'
  params:{
    location: location
    storageName: storageName
  }
}
