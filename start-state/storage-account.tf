

resource "azurerm_storage_account" "tfstate_sa" {
  name                     = "tfstateltmserverlesspoc"
  resource_group_name      = azurerm_resource_group.serverless-group.name
  location                 = azurerm_resource_group.serverless-group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"

  tags = {
    environment = "development"
  }
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstatecontainer"
  storage_account_name  = azurerm_storage_account.tfstate_sa.name
  container_access_type = "private"
}

