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
