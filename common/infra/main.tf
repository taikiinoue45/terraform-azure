terraform {
  required_version = "0.13.6"
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate20210329114422"
    container_name       = "tfstate"
    key                  = "common.terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.52.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "somic"
  tags     = var.tags
  location = "Japan East"
}

resource "azurerm_storage_account" "storage" {
  name                     = "storage${var.suffix}"
  tags                     = var.tags
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

resource "azurerm_container_registry" "registry" {
  name                = "registry${var.suffix}"
  tags                = var.tags
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = true
}
