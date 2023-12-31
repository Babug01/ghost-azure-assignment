targetScope = 'resourceGroup'

@minLength(3)
@maxLength(63)
param mySQLServerName string

@description('Fully Qualified DNS Name')
param fullyQualifiedDomainName string = '${mySQLServerName}.mysql.database.azure.com'

@description('Azure database for MySQL pricing tier')
@allowed([
  'GeneralPurpose'
  'MemoryOptimized'
  'Burstable'
])
param mySQLServerSkuTier string = 'Burstable'

@description('Azure database for MySQL sku name ')
param mySQLServerSku string = 'Standard_B1s'

@description('Azure database for MySQL storage Size ')
param StorageSizeGB int = 20

@description('Azure database for MySQL storage Iops')
param StorageIops int = 360

@description('MySQL version')
@allowed([
  '5.7'
  '8.0.21'
])
param mysqlVersion string = '8.0.21'

@description('Database administrator login name')
@minLength(1)
param administratorLogin string

@description('Database administrator password')
@minLength(8)
@maxLength(128)
@secure()
param administratorPassword string

@description('Database name')
param databaseName string

@description('Location to deploy the resources')
param location string = resourceGroup().location

@description('MySQL Server backup retention days')
param backupRetentionDays int = 7

@description('Geo-Redundant Backup setting')
@allowed([
  'Enabled'
  'Disabled'
])
param mysqlgeoRedundantBackup string = 'Disabled'

@description('High Availability mode')
@allowed([
  'Enabled'
  'Disabled'
])
param mysqlHighAvailabilityMode string = mySQLServerSkuTier == 'Burstable' ? 'Disabled' : 'Enabled'

resource mySQLServer 'Microsoft.DBforMySQL/flexibleServers@2021-05-01' = {
  name: mySQLServerName
  location: location
  sku: {
    name: mySQLServerSku
    tier: mySQLServerSkuTier
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword
    storage: {
      autoGrow: 'Enabled'
      iops: StorageIops
      storageSizeGB: StorageSizeGB
    }
    createMode: 'Default'
    version: mysqlVersion
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: mysqlgeoRedundantBackup
    }
    highAvailability: {
      mode: mysqlHighAvailabilityMode
    }
  }
}

resource firewallRules 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2021-05-01' = {
  parent: mySQLServer
  name: 'AllowAzureIPs'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource databases 'Microsoft.DBforMySQL/flexibleServers/databases@2021-05-01' = {
  name: databaseName
  parent: mySQLServer
  properties: {
    charset: 'utf8mb3'
    collation: 'utf8mb3_general_ci'
  }
}

output name string = mySQLServerName
output fullyQualifiedDomainName string = fullyQualifiedDomainName
