data "azurerm_resource_group" "rg" {
  name = "somic"
}

data "azurerm_storage_account" "storage" {
  name                = "storage20210324165333"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_container_registry" "registry" {
  name                = "registry20210324165333"
  resource_group_name = data.azurerm_resource_group.rg.name
}
