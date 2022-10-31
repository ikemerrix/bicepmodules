param location string = resourceGroup().location
param adminPassword string
param adminUsername string
param domainJoinUserName string
param domainJoinUserPassword string
param vmList array
param vNet string

module vm '../../bicepmodules/virtualMachine/vm.bicep' = {
  name: 'vmDeploy'
  params: {
    location:location
    adminPassword:adminPassword
    adminUsername:adminUsername
    domainJoinUserName:domainJoinUserName
    domainJoinUserPassword:domainJoinUserPassword
    vmList:vmList
    vNet:vNet
  }
}
