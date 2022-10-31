@description('Name of the App Service Plan')
param appServiceName string
@description('ID of App Service Plan.')
param appServicePlanName string
@description('Location.')
param location string
// @description('Name of the Application Insights')
// param applicationInsightsName string
param sku string
param skuCapacity int

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
    capacity: skuCapacity
  }
}
resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceName
  location: location
  properties:{
    serverFarmId: appServicePlan.id
    siteConfig:{
      alwaysOn: true
      ftpsState: 'Disabled'
      netFrameworkVersion: 'v6.0'
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': appInsights.properties.InstrumentationKey
        }     
      ]
    }
    httpsOnly: true    
  }
}
output appServiceId string = appService.id

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appServiceName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}
output instrumentationKey string = appInsights.properties.InstrumentationKey
