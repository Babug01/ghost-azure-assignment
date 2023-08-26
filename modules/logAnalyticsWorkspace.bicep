targetScope = 'resourceGroup'

@description('Log Analytics workspace name')
@minLength(4)
@maxLength(64)
param logAnalyticsWorkspaceName string

@description('Log Analytics workspace pricing tier')
@allowed([
  'Free'
  'Unlimited'
  'CapacityReservation'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
param logAnalyticsWorkspaceSku string

@description('Log Analytics workspace data retention in days')
param retentionInDays int

@description('Location to deploy the resources')
param location string = resourceGroup().location

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: logAnalyticsWorkspaceSku
    }
    retentionInDays: retentionInDays
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}

output id string = logAnalyticsWorkspace.id
