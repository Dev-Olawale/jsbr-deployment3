# Configure the Azure provider and version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

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

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "jsbrcr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}

# Create App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "jsbr-deployment-appServiceplan"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "S1"
  os_type             = "Linux"
}

# Create App Service for Linux Container
resource "azurerm_linux_web_app" "lwapp" {
  name                       = "jsbr-deployment-webApp"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.asp.id
  https_only                 = true
  client_certificate_enabled = true

  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/<docker-image-name>:$(tag)"
  }
}

# Create Container Registry Webhook
resource "azurerm_container_registry_webhook" "webhooks" {
  name                = "jsbrdeploymentwebAppHook"
  location            = var.location
  resource_group_name = var.resource_group_name
  registry_name       = "jsbrcr"
  service_uri         = "https://${azurerm_linux_web_app.lwapp.name}.azurewebsites.net/docker/hook"
  actions             = ["push"]
  scope               = "azurerm_container_registry.acr.name:$(tag)"
  status              = "enabled"
  custom_headers = {
    "X-Custom-Header" = "CustomValue"
  }
}

# Monitoring - app insight
resource "azurerm_application_insights" "insight" {
  name                = "jsbr-insight"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "java"
  retention_in_days   = 30
}
