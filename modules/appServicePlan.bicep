targetScope = 'resourceGroup'

@description('App Service Plan name')
@minLength(1)
@maxLength(40)
param appServicePlanName string

@description('App Service Plan pricing tier')
@allowed([
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1V2'
  'P2V2'
  'P3V2'
])
param appServicePlanSku string

@description('Location to deploy the resources')
param location string = resourceGroup().location

@description('Autoscaling Setting options')
param minimumCapacity string = '2'
param maximumCapacity string = '5'
param defaultCapacity string = '5'
param metricName string = 'CpuPercentage'
param metricThresholdToScaleOut int = 60
param metricThresholdToScaleIn int = 20
param changePercentScaleOut string = '20'
param changePercentScaleIn string = '10'
param autoscaleEnabled bool = true

@description('Log Analytics workspace id to use for diagnostics settings')
param logAnalyticsWorkspaceId string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: appServicePlanSku
  }
}

resource autoscaleSettings 'Microsoft.Insights/autoscalesettings@2022-10-01' = {
  name: toLower('${appServicePlanName}-setting')
  dependsOn: [
    appServicePlan
  ]
  location: location
  properties: {
    profiles: [
      {
        name: 'DefaultAutoscaleProfile'
        capacity: {
          minimum: minimumCapacity
          maximum: maximumCapacity
          default: defaultCapacity
        }
        rules: [
          {
            metricTrigger: {
              metricName: metricName
              metricResourceUri: resourceId('Microsoft.Web/serverFarms', appServicePlanName)
              timeGrain: 'PT5M'
              statistic: 'Average'
              timeWindow: 'PT10M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: metricThresholdToScaleOut
            }
            scaleAction: {
              direction: 'Increase'
              type: 'PercentChangeCount'
              value: changePercentScaleOut
              cooldown: 'PT10M'
            }
          }
          {
            metricTrigger: {
              metricName: metricName
              metricResourceUri: resourceId('Microsoft.Web/serverFarms', appServicePlanName)
              timeGrain: 'PT5M'
              statistic: 'Average'
              timeWindow: 'PT10M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: metricThresholdToScaleIn
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'PercentChangeCount'
              value: changePercentScaleIn
              cooldown: 'PT10M'
            }
          }
        ]
      }
    ]
    enabled: autoscaleEnabled
    targetResourceUri: resourceId('Microsoft.Web/serverFarms', appServicePlanName)
  }
}

resource appServicePlanDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: appServicePlan
  name: 'AppServicePlanDiagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output id string = appServicePlan.id
