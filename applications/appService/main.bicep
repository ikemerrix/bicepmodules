param location string
param sku string 
param appServiceName string
param appServicePlanName string
param skuCapacity int



module appService '../../bicepmodules/appService/appservice.bicep' = {
  name: 'appserviceDeploy'
  params:   {
    location: location
    sku: sku
    appServiceName: appServiceName
    appServicePlanName: appServicePlanName
    skuCapacity: skuCapacity
  }
}
