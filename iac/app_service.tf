# Create App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = var.asp_name
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
  
  site_config {
  }
}

# Monitoring - app insight
resource "azurerm_application_insights" "insight" {
  name                = var.insight_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "java"
  retention_in_days   = 30
  
  depends_on = [azurerm_container_registry.acr]
}
