param appServiceName string
param storageAccountName string
param sqlServerName string
param databaseName string
param sqlAdminUser string
param sqlLocation string = 'centralus'

@secure()
param sqlAdminPassword string


var location = resourceGroup().location




resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location

  sku: {
    name: 'Standard_LRS'
  }

  kind: 'StorageV2'
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${appServiceName}-plan'

  location: location

  sku: {
    tier: 'Basic'
    name: 'B1'
  }
}

resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: appServiceName

  location: location

  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: sqlServerName

  location: sqlLocation

  properties: {
    administratorLogin: sqlAdminUser
    administratorLoginPassword: sqlAdminPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  parent: sqlServer
  location: sqlLocation
  name: databaseName

  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
}

output appServiceName string = appService.name

output appServiceDefaultHostName string = appService.properties.defaultHostName

output sqlServerFQDN string = sqlServer.properties.fullyQualifiedDomainName

output sqlDatabaseName string = sqlDatabase.name

output storageAccountId string = storageAccount.id
output appServicePlanId string = appServicePlan.id
output sqlServerId string = sqlServer.id
output sqlDatabaseId string = sqlDatabase.id
