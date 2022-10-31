param vnetSuffix string = '001'
param vnetaddressPrefix string = '10.0.0.0/15'
param subnetaddressPrefix string = '10.0.0.0/24'
param subnetName string = 'demoSubNet'
param dnsServer string = '10.0.0.4'
param createUserDefinedRoutes bool = true
param udrName string = 'demoUserDefinedRoute'
param udrRouteName string = 'demoRoute'
param addressPrefix string = '0.0.0.0/24'
param nextHopType string = 'VirtualAppliance'
param nextHopIpAddress string = '10.10.3.4'
param location string = resourceGroup().location

module vm '../../bicepmodules/virtualNetwork/vnet.bicep' = {
  name: 'vNetDeploy'
  params: {
    vnetSuffix: vnetSuffix
    vnetaddressPrefix: vnetaddressPrefix
    subnetaddressPrefix : subnetaddressPrefix
    subnetName : subnetName
    dnsServer : dnsServer
    createUserDefinedRoutes: createUserDefinedRoutes
    udrName : udrName
    udrRouteName : udrRouteName
    addressPrefix : addressPrefix
    nextHopType : nextHopType
    nextHopIpAddress : nextHopIpAddress
    location : location
  }
}
