param logAnalyticsWorkspaceName string
param location string = resourceGroup().location

module loganalytics '../../bicepmodules/logAnalytics/loganalytics.bicep' = {
  name: 'loganalyticsdeploy'
  params:{
    location: location
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}
