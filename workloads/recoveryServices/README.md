# Welcome to the Azure Vending Machine Recovery Services Vault Deployment!
This workload solution deploys Recovery Services Vaults and associated Azure Policy with best-practice configurations to an Azure Management Group. 

[Internal Documentation](https://microage.huducloud.com)

## Overview

Welcome to the Recovery Services repository! 🚀

This repository houses baseline templates and deployments for Recovery Services in Azure. 

## Getting Started

This template assists with deploying Recovery Services and associated policies within an Azure environment. The template follows MicroAge Services best practices for backup and recovery in Azure. You can find more details around policy configurations in the Hudu link above.

There are two options for Deployment, Azure Portal UI, or a bicep template. 

| Deployment Type | Link |
|:--|:--|
| Azure portal UI |[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicroAgeServicesOrg%2Fazure-vending-machine%2Frefs%2Fheads%2Fmain%2Fworkloads%2FrecoveryServices%2Farm%2Fmain.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FMicroAgeServicesOrg%2Fazure-vending-machine%2Frefs%2Fheads%2Fmain%2Fworkloads%2FrecoveryServices%2Fportal-ui%2Fportal-ui.json) |
| Command line (Bicep/ARM) | [![Powershell/Azure CLI](./workload/docs/icons/powershell.png)](./workload/bicep/readme.md#avd-accelerator-baseline) |

## Parameters

**The following parameters are required**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Azure Region for Deployment. |
| [`subscriptionID`](#parameter-subscriptionID) | string | Subscription ID of the Subscription that the vault and resource group will be deployed to. |
| [`backupRGName`](#parameter-backupRGName) | string | The name of the resource group to house the recovery vault.|
| [`vaultName`](#parameter-vaultName) | string | The name of the backup vault. |
| [`assignmentMgmtGroupID`](#parameter-assignmentMgmtGroupID) | string | The ID of the management group to assign the policy to.