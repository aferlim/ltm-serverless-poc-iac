resource "azurerm_storage_account" "function_storage" {
  name                     = var.storage_function_name
  location                 = var.storage_function_location
  resource_group_name      = var.storage_function_resource_group
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
