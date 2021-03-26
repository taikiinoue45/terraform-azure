data "azurerm_resource_group" "rg" {
  name = "somic"
}

data "azurerm_storage_account" "storage" {
  name                = "storage20210326102834"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_container_registry" "registry" {
  name                = "registry20210326102834"
  resource_group_name = data.azurerm_resource_group.rg.name
}
