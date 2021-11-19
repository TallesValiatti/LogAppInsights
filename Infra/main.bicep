// cli
// az deployment sub create --template-file Infra/main.bicep --location centralus

// Scope
targetScope = 'subscription'

// Shared variables
var location = deployment().location

// AppService variables
var rgName = 'rg-log-insights'
var appServiceName = 'as-log-insights'
var appServicePlanName = 'asp-log-insights'
var appServicePlanSku = 'F1'
var appServiceRuntime = 'DOTNETCORE|5.0'

// LogAnalyticsWorkspace variables
var logAnalyticsWorkspaceName = 'laws-log-insights'

// AppInsights variables
var appInsightName = 'ai-log-insights'

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
