param location string
param keyvaultName string

module keyvault '../../bicepmodules/keyVaults/keyvault.bicep' = {
  name: 'keyvaultDeploy'
  params:{
    location: location
    keyvaultName: keyvaultName
  }
}
