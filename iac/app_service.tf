# Create App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = var.azurerm_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "S1"
  os_type             = "Linux"
    
  depends_on = [azurerm_container_registry.acr]
}

# Create App Service for Linux Container
resource "azurerm_linux_web_app" "lwapp" {
  name                       = var.lwapp_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.asp.id
  https_only                 = true
  client_certificate_enabled = true

  site_config {
    always_on        = true
    #linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/<docker-image-name>:$(tag)"
  }
}

# Create Container Registry Webhook
resource "azurerm_container_registry_webhook" "webhooks" {
  name                = var.webhooks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  registry_name       = var.acr_name
  #service_uri         = "https://${azurerm_linux_web_app.lwapp.name}.azurewebsites.net/docker/hook"
  actions             = ["push"]
  scope               = "azurerm_container_registry.acr.name:$(tag)"
  status              = "enabled"
  custom_headers = {
    "X-Custom-Header" = "CustomValue"
  }
}

# Monitoring - app insight
resource "azurerm_application_insights" "insight" {
  name                = var.insight_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "java"
  retention_in_days   = 30
}
