param nsgName string 
param location string = resourceGroup().location

module nsg '../../bicepmodules/nsg/nsg.bicep' = {
  name: 'nsgDeploy'
  params:{
    location: location
    nsgName: nsgName
  }
}
