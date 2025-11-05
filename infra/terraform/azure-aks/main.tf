
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.7" }
  }
}
provider "azurerm" { features {} }

resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-rg"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.name

  default_node_pool {
    name       = "system"
    node_count = 2
    vm_size    = "Standard_DS3_v2"
  }

  identity { type = "SystemAssigned" }
  kubernetes_version = var.kubernetes_version
}

output "kubeconfig" {
  value = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${var.name} --overwrite-existing"
}
