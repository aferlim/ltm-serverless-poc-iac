resource "azurerm_resource_group" "serverless-group" {
  name     = var.POC_Resource_Group
  location = var.POC_Azure_Region
}
