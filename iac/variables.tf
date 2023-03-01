# Define variables for resource names and locations
variable "resource_group_name" {
  description = "The resource group for the java react app deployment"
  default = "jsbr-RG"
}

variable "location" {
  description = "The Azure Region were the resource should exist"
  default = "westeurope"
}

variable "acr_name" {
  description = "The Azure Container Registry for the java react app deployment Docker image"
  default = "jsbrcr"
}

variable "asp_name" {
  description = "The app service plan for the java react app deployment webApp"
  default = "jsbr-deployment-appServiceplan"
}

variable "webhooks_name" {
  description = "The Webhook for the container registry created for the java react app deployment"
  default = "jsbrdeploymentwebAppHook"
}

variable "insight_name" {
  description = "The Azure monitor insight"
  default = "jsbr-insight"
}

variable "lwapp_name" {
  description = "The Azure linux webApp wher the java react app deployment docker image is deployed"
  default = "jsbr-deployment-webApp-linux"
}
