param name string
param location string = resourceGroup().location
param tags object = {}

param appCommandLine string = ''
param appServicePlanId string
param serviceName string = 'helloworld'

module helloworld '../core/host/appservice.bicep' = {
  name: '${name}-app-module'
  params: {
    name: name
    location: location
    tags: union(tags, { 'azd-service-name': serviceName })
    appCommandLine: appCommandLine
    appServicePlanId: appServicePlanId
    runtimeName: 'node'
    runtimeVersion: '18-lts'
    scmDoBuildDuringDeployment: true
  }
}

output SERVICE_HELLOWORLD_IDENTITY_PRINCIPAL_ID string = helloworld.outputs.identityPrincipalId
output SERVICE_HELLOWORLD_NAME string = helloworld.outputs.name
output SERVICE_HELLOWORLD_URI string = helloworld.outputs.uri
