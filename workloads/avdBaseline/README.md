# Deploy Azure AVD Baseline Resources
This deployment will create the resources necessary to deploy production AVD via Nerdio. This deployment adheres to our best practice and deployment standards and is directly derived from the [Enterprise-Scale for Azure Virtual Desktop](https://docs.microsoft.com/azure/cloud-adoption-framework/scenarios/wvd/ready).

- Resource Groups required for all AVD Resources
- Spoke Virtual Network for AVD Deployments including routes and peers
- Storage resources for profile disks (FSLogix)

## Pre-requisites

- Azure Tenant and Subscription and Client Information

## Deployment

The easiest method is to configure the deployment via the provided blue buttons as they include the custom UI for configuring the options.  However, you can also utilize PowerShell and the Azure CLI.

## Architecture Diagram