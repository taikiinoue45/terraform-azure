terraform {
  required_version = "0.13.6"
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

resource "azurerm_storage_container" "container" {
  name                  = "${var.prefix}"
  storage_account_name  = data.azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.prefix}-plan"
  tags                = var.tags
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Premium"
    size = "P1V2"
  }
}

resource "azurerm_function_app" "func" {
  name                       = "${var.prefix}-func"
  tags                       = var.tags
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  storage_account_name       = data.azurerm_storage_account.storage.name
  storage_account_access_key = data.azurerm_storage_account.storage.primary_access_key
  version                    = "~2"

  app_settings = {
    FUNCTION_APP_EDIT_MODE              = "readOnly"
    https_only                          = true
    DOCKER_REGISTRY_SERVER_URL          = data.azurerm_container_registry.registry.login_server
    DOCKER_REGISTRY_SERVER_USERNAME     = data.azurerm_container_registry.registry.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD     = data.azurerm_container_registry.registry.admin_password
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }

  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|${data.azurerm_container_registry.registry.login_server}/${var.docker_image}"
  }
}
