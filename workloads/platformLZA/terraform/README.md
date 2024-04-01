# vending-machine

create a [deploymentName].tfvars

populate the tfvars file with the following:

/* Global Variables */
DeploymentRegion = ""

/* Resource Group Variables */
NetworkRgName = ""
ServerRgName = ""

/* Network Resources */
  /* HUB Vnet */
HubVnetName = ""
HubVnetAddrSpc = ""

  /* HUB Subnets */
GwSubnetName = ""
GwSubnetAddrSpc = ""

DomainSubnetName = ""
DomainSubnetAddrSpc = ""

EndpointSubnetName = ""
EndpointSubnetAddrSpc = ""

BastionSubnetAddrSpc = ""

  /* Server Vnet */
ServerVnetName = ""
ServerVnetAddrSpc = ""

  /* Server Subnets */
ServerSubnetName = ""
ServerSubnetAddrSpc = ""

/* Peering Hub to Server */
Hub2SrvPeeringName = "
Srv2HubPeeringName = ""
UseHubGw = "true"
UseSrvGw = "false"


