targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param serviceName string = ''
param appServicePlanName string = ''
param resourceGroupName string = ''

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'azd-env-name': environmentName }

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

// The application backend
module helloworld './app/helloworld.bicep' = {
  name: 'helloworld'
  scope: rg
  params: {
    name: !empty(serviceName) ? serviceName : '${abbrs.webSitesAppService}helloworld-${resourceToken}'
    location: location
    tags: tags
    appServicePlanId: appServicePlan.outputs.id
  }
}

// Create an App Service Plan to group applications under the same payment plan and SKU
module appServicePlan './core/host/appserviceplan.bicep' = {
  name: 'appserviceplan'
  scope: rg
  params: {
    name: !empty(appServicePlanName) ? appServicePlanName : '${abbrs.webServerFarms}${resourceToken}'
    location: location
    tags: tags
    sku: {
      name: 'B1'
    }
  }
}

// App outputs
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output SERVICE_API_ENDPOINTS array = [ helloworld.outputs.SERVICE_HELLOWORLD_URI ]
