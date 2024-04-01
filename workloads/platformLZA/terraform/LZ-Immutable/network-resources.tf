resource "azurerm_virtual_network" "hub_vnet"{
  location            = var.DeploymentRegion
  name                = var.HubVnetName
  resource_group_name = var.NetworkRgName

  address_space       = [var.HubVnetAddrSpc]

  subnet {
    name           = var.GwSubnetName
    address_prefix = var.GwSubnetAddrSpc
  }

  subnet {
    name           = var.DomainSubnetName
    address_prefix = var.DomainSubnetAddrSpc
  }

  subnet {
    name           = "AzureBastionSubnet"
    address_prefix = var.BastionSubnetAddrSpc
  }

  subnet {
    name           = var.EndpointSubnetName
    address_prefix = var.EndpointSubnetAddrSpc
  }

  depends_on = [
    azurerm_resource_group.network_rg
  ]
}

resource "azurerm_virtual_network" "srv_vnet" {
  location            = var.DeploymentRegion
  name                = var.ServerVnetName
  resource_group_name = var.NetworkRgName

  address_space       = [var.ServerVnetAddrSpc]
  dns_servers         = [var.DnsServer1, var.DnsServer2]

  subnet {
    name           = var.ServerSubnetName
    address_prefix = var.ServerSubnetAddrSpc
  }

  depends_on = [
    azurerm_resource_group.network_rg
  ]
}

/* Peering ------------------------- */

resource "azurerm_virtual_network_peering" "srv2hub_peer" {
  name                         = var.Srv2HubPeeringName
  resource_group_name          = azurerm_resource_group.network_rg.name
  virtual_network_name         = azurerm_virtual_network.srv_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic      = true
  use_remote_gateways          = var.UseHubGw
  allow_virtual_network_access = true # (Optional) Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to true.
  allow_gateway_transit        = var.UseSrvGw

  depends_on = [ 
    azurerm_virtual_network.srv_vnet, 
    azurerm_virtual_network.hub_vnet,
  ]
}

resource "azurerm_virtual_network_peering" "hub2srv_peer" {
  name                         = var.Hub2SrvPeeringName
  resource_group_name          = azurerm_resource_group.network_rg.name
  virtual_network_name         = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.srv_vnet.id
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.UseHubGw
  use_remote_gateways          = var.UseSrvGw
  allow_virtual_network_access = true # (Optional) Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to true.

  depends_on = [ 
    azurerm_virtual_network.srv_vnet, 
    azurerm_virtual_network.hub_vnet,
  ]
}