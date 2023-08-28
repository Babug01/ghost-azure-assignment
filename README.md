# azure - ghost blog app

A one-click [Ghost](https://ghost.org/) deployment on [Azure Web App for Containers](https://azure.microsoft.com/en-us/services/app-service/containers/).

## One-click deploy

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FBabug01%2Fghost-azure-assignment%2Fmain%2Fghost.json)

[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FBabug01%2Fghost-azure-assignment%2Fmain%2Fghost.json)

## Ghost App + Application Insights Integration

[**Custom Ghost Docker image**](https://hub.docker.com/repository/docker/babug011/ghostapp/general) that uses the [**original Ghost image**](https://hub.docker.com/_/ghost) as the base one and extends it with Azure Application Insights support.

- Created Dockerfile with Ghost app and application insights configuration
- For each commit to the folder: **ghostapp/**, CI pipeline will be triggered to build and push the docker image to my [**Docker Hub** ](https://hub.docker.com/repository/docker/babug011/ghostapp/general)

## Azure Web App Infrastructure for Ghost Application

This repository contains an ARM template that deploys and configures the required Azure resources for hosting a containerized web application. The infrastructure is designed to fulfill the following requirements:

- Scalability to handle varying loads.
- Consistent application behavior across user sessions.
- Resilient architecture for high availability.
- Observability for monitoring and diagnostics.
- Automated deployment of resources.
- Utilizes Azure Cloud services for the entire infrastructure.

## Infrastructure Overview

The ARM template in this repository provisions the following resources:

- **Azure Web App and App Hosting Plan:** Hosts the containerized web application.
- **Azure Key Vault:** Safely stores sensitive information like database passwords.
- **Log Analytics Workspace and Application Insights:** Monitors the application's performance and health.
- **Azure Database for MySQL Flexible:** Provides a database backend for the application.
- **Azure Front Door or Azure CDN:** Offloads traffic from the web app for improved performance.
- **Azure Storage Account:** Serves the Ghost site contents.

## Deployment Instructions

Follow these steps to deploy the infrastructure:

1. [**Click here to deploy**](https://aka.ms/deploytoazurebutton) the ARM template to your Azure subscription.
   _(Provide a link or instructions to deploy the ARM template from your preferred location.)_

2. Fill in the required parameters in the deployment wizard, such as resource group name, region, application settings, etc.

3. Review the deployment settings and click "Review + Create" button to initiate the provisioning process.

4. Once the deployment is complete, you'll receive the necessary information to access and manage the resources.

### Monitoring and Observability

- **Log Analytics Workspace:** The Log Analytics workspace provides centralized monitoring and analytics for the application's logs and telemetry data.

- **Application Insights:** Application Insights provides real-time insights into the application's performance, user behavior, and exceptions.

### Scaling and Resilience

The Azure Web App's scaling configuration can be adjusted based on load using Azure's built-in autoscaling features.

_For resilience, the architecture includes_:

- **Azure Front Door:** Provides automatic failover across regions and global load balancing to ensure availability in case of regional failures.

- **Azure Database for MySQL Flexible Server:** Offers high availability configurations like geo-replication and automated backups.

## Automation and Deployment

The provided ARM template automates the deployment of the entire infrastructure. You can also consider using Azure Resource Manager templates in combination with Azure DevOps pipelines for a more advanced CI/CD setup.

## Contact

If you have any questions, encounter issues, or need assistance, please contact at [sachinbabu12@gmail.com].

---
