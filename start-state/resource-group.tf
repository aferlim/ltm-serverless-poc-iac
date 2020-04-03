resource "azurerm_resource_group" "serverless-group" {
  name     = var.Resource_Group
  location = var.AZ_REGION

  tags = {
    environment = "staging"
  }

}
