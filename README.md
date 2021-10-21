# Github Actions Sample
This project uses a project using a .Net core application, add dependencies, does the test checks, builds a `Docker` image, and sends it to a `Docker` container.  The CI/CD will then host the docker container in an Azure App Service.

## Azure App Service
I also try to mimic how to deploy to an existing Azure App Service plan.

First, you will need to create a new App Service plan.

```
az login

resourceGroup=appServiceDemoGroup
appServicePlan=demoAppService
webApp=dotNetDemoWebApp
runTime="DOTNET|5.0"
dockerImage="mfolivas/dotnet-app:latest"
location=eastus

az group create --name $resourceGroup --location $location

az appservice plan create \
    --resource-group $resourceGroup \
    --name $appServicePlan \
    --is-linux
```
Create a web app:
```
az webapp create \
    --name $webApp \
    --plan $appServicePlan \
    --resource-group $resourceGroup \
    --deployment-container-image-name $dockerImage
```

A publish profile is an app-level credential. Set up your publish profile as a GitHub secret.

1. Go to your app service in the Azure portal.
2. On the Overview page, select Get Publish profile.
3. Save the downloaded file. You'll use the contents of the file to create a GitHub secret.

Make sure to add the name of the app in the environments for the github actions.

To delete everything:
```
az group delete --name $resourceGroup --yes --no-wait
```

