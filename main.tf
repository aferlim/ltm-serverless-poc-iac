resource "azurerm_storage_account" "static_website" {
  account_replication_type  = "GRS"
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  location                  = azurerm_resource_group.serverless-group.location
  name                      = var.POC_StaticFile_Name
  resource_group_name       = azurerm_resource_group.serverless-group.name
  enable_https_traffic_only = true

  static_website {
    index_document     = "index.html"
    error_404_document = "error.html"
  }
}

resource "azurerm_signalr_service" "serverless_signalr" {
  name                = "serverlesspoc-signalr"
  location            = azurerm_resource_group.serverless-group.location
  resource_group_name = azurerm_resource_group.serverless-group.name

  sku {
    name     = "Standard_S1"
    capacity = 2
  }

  cors {
    allowed_origins = ["*"]
  }

  features {
    flag  = "ServiceMode"
    value = "Serverless"
  }

  features {
    flag  = "EnableConnectivityLogs"
    value = "True"
  }
}

resource "azurerm_storage_account" "function_storage" {
  name                     = "votepocstorage"
  location                 = azurerm_resource_group.serverless-group.location
  resource_group_name      = azurerm_resource_group.serverless-group.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_app_service_plan" "serverless_plan" {
  name                = "serverlessplan"
  location            = azurerm_resource_group.serverless-group.location
  resource_group_name = azurerm_resource_group.serverless-group.name

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_function_app" "vote_function" {
  version                   = "~2"
  name                      = "votepoc"
  location                  = azurerm_resource_group.serverless-group.location
  resource_group_name       = azurerm_resource_group.serverless-group.name
  app_service_plan_id       = azurerm_app_service_plan.serverless_plan.id
  storage_connection_string = azurerm_storage_account.function_storage.primary_connection_string

  app_settings = {
    "AzureSignalRConnectionString" : azurerm_signalr_service.serverless_signalr.primary_connection_string
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" : "true"
    "WEBSITE_RUN_FROM_PACKAGE" : "1"
  }

  site_config {
    cors {
      allowed_origins     = ["*"]
      support_credentials = false
    }
  }
}
