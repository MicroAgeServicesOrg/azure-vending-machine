# Welcome to the Azure Vending Machine Domain Controller Deployment!
This workload solution deploys domain controllers with best-practice configurations to an Azure tenant. 

[Internal Documentation](https://microage.huducloud.com)

## Overview

Welcome to the Azure Quickstart Templates repository! 🚀

This repository houses baseline templates and deployments for Domain Controllers in Azure. 

## Getting Started

This template assists with deploying domain controllers within an Azure environment. The template follows MicroAge Services best practices for building, deploying, and extending the domain into Azure.

There are two options for Deployment, Azure Portal UI, or a bicep template. 

| Deployment Type | Link |
|:--|:--|
| Azure portal UI |[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicroAgeServicesOrg%2Fazure-vending-machine%2Frefs%2Fheads%2Fmain%2Fworkloads%2FdomainController%2Farm%2Fmain.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FMicroAgeServicesOrg%2Fazure-vending-machine%2Frefs%2Fheads%2Fmain%2Fworkloads%2FdomainController%2Fportal-ui%2Fportal-ui.json) |
| Command line (Bicep/ARM) | [![Powershell/Azure CLI](./workload/docs/icons/powershell.png)](./workload/bicep/readme.md#avd-accelerator-baseline) |

## Parameters

**The following parameters are required**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-adminusername) | string | Azure Region for Deployment. |
| [`addsSubnetId`](#parameter-imagereference) | string | Resource Id of the subnet for ADDS. This subnet is typically found in the primary region's hub vNet. |
| [`dcPrefix`](#parameter-name) | string | The prefix of the VM name. Typically the CAF Region shortcode. e.g. "wus3" |
| [`dcCount`](#parameter-nicconfigurations) | int | Amount of VMs (DCs) you would like to deploy. |
| [`zones`](#parameter-osdisk) | object | The Azure zones you would like to utilize. Note, the deployment will deploy in numerical order. |
| [`domainName`](#parameter-ostype) | string | The domain name you would like to join the DCs to. (e.g. contoso.local) |
| [`domainSiteName`](#parameter-vmsize) | string | Specify the AD Site for the domain controllers. |
| [`domainAdminUsername`](#parameter-zone) | string | Domain Admin Username |
| [`domainAdminPassword`](#parameter-zone) | secureString | Domain Admin Password |
 [`safeModeUsername`](#parameter-zone) | string | Safe mode (recovery) username |
  [`safeModePassword`](#parameter-zone) | secureString | Safe mode (recovery) password