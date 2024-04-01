resource "azurerm_resource_group" "network_rg" {
  name                = var.NetworkRgName
  location            = var.DeploymentRegion
}

resource "azurerm_resource_group" "server_rg" {
  name                = var.ServerRgName
  location            = var.DeploymentRegion
}
