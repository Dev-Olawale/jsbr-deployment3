# Define variables for resource names and locations
variable "resource_group_name" {
  default = "jsbr-RG"
}

variable "location" {
  default = "westeurope"
}

variable "acr_name" {
  default = "jsbrcr"
}

variable "azurerm_service_plan_name" {
  default = "jsbr-deployment-appServiceplan"
}
