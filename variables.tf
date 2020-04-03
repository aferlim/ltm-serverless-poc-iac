variable "tf_state_resource_group" {
  default = "terraform-state"

}

variable "tf_storage_account_name" {
  default = "tfstateltmserverlesspoc"
}

variable "tf_container_name" {
  default = "tfstatecontainer"
}

variable "POC_Azure_Region" {
  default = "East US"
}

variable "POC_Resource_Group" {
  default = "terraform-serverless-poc"
}

variable "POC_StaticFile_Name" {
  default = "ltmserverlessstatic"
}

variable "AzSubscriptionId" {
  default = "660d3b8a-8752-4b02-87f5-e4b07c5ac69e"
}
