// cli
// az deployment sub create --template-file Infra/main.bicep --location centralus
// az group delete --name rg-log-insights-prod

// Scope
targetScope = 'subscription'

// Shared variables
var location = deployment().location

// AppService variables
var rgName = 'rg-log-insights-prod'
var appServiceName = 'apps-log-insights-prod'
var appServicePlanName = 'appsp-log-insights-prod'
var appServicePlanSku = 'B1'
var appServiceRuntime = 'DOTNETCORE|6.0'

// LogAnalyticsWorkspace variables
var logAnalyticsWorkspaceName = 'logaws-log-insights-prod'

// AppInsights variables
var appInsightName = 'appi-log-insights'

resource rg 'Microsoft.Resources/resourceGroups@2020-10-01' = {
  location: location
  name: rgName
}

module appServiceModule './Modules/webApp.bicep' = {
  name: 'webAppModule'
  scope: rg
  params: {
    name: appServiceName
    servicePlanName: appServicePlanName
    sku: appServicePlanSku
    linuxFxVersion: appServiceRuntime
  }
}

module logAnalyticsWorkspaceModule './Modules/logAnalyticsWorkspace.bicep' = {
  name: 'logAnalyticsWorkspaceModule'
  scope: rg
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}

module appInsightsModule './Modules/appInsights.bicep' = {
  name: 'appInsightsModule'
  scope: rg
  params: {
    appInsightName: appInsightName
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceModule.outputs.logAnalyticsWorkspaceId
  }
}
