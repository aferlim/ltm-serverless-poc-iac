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

# resource "azurerm_storage_account" "function_storage" {
#   name                     = "votepocstorage"
#   location                 = azurerm_resource_group.serverless-group.location
#   resource_group_name      = azurerm_resource_group.serverless-group.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

module "storage_account_function" {
  source = "./modules/account-storage"

  storage_function_name           = "votepocstorage"
  storage_function_location       = azurerm_resource_group.serverless-group.location
  storage_function_resource_group = azurerm_resource_group.serverless-group.name

}


resource "azurerm_app_service_plan" "serverless_plan" {
  name                = "serverlessplan"
  location            = azurerm_resource_group.serverless-group.location
  resource_group_name = azurerm_resource_group.serverless-group.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_application_insights" "application_insights" {
  name                = "serverless-appInsights"
  location            = azurerm_resource_group.serverless-group.location
  resource_group_name = azurerm_resource_group.serverless-group.name
  application_type    = "web"
}


resource "azurerm_function_app" "vote_function" {
  version                   = "~2"
  name                      = "votepoc"
  location                  = azurerm_resource_group.serverless-group.location
  resource_group_name       = azurerm_resource_group.serverless-group.name
  app_service_plan_id       = azurerm_app_service_plan.serverless_plan.id
  storage_connection_string = module.storage_account_function.primary_connection_string

  app_settings = {
    "AzureSignalRConnectionString" : azurerm_signalr_service.serverless_signalr.primary_connection_string
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" : "true"
    "WEBSITE_RUN_FROM_PACKAGE" : "1"
    "APPINSIGHTS_INSTRUMENTATIONKEY" : azurerm_application_insights.application_insights.instrumentation_key
  }

  site_config {
    cors {
      allowed_origins     = ["*"]
      support_credentials = false
    }
  }
}


data "azurerm_storage_account" "cloudshell" {
  name                = "cs2100300009a1a5d12"
  resource_group_name = "cloud-shell-storage-eastus"
}
