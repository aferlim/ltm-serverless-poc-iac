output "Webstatic_endpoint" {
  value = azurerm_storage_account.static_website.primary_web_endpoint
}

output "Webstatic_secondary_endpoint" {
  value = azurerm_storage_account.static_website.secondary_web_endpoint
}

output "static_website_storage_primary_connection_string" {
  value = azurerm_storage_account.static_website.primary_connection_string
}

output "function_storage_storage_primary_connection_string" {
  value = azurerm_storage_account.static_website.primary_connection_string
}
