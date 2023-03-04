# Configure the Azure provider and version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "terraform-RG"
    storage_account_name = "jsbrtorageaccounts"
    container_name       = "jsbrcontainer"
    key                  = "jsbrterraform.tfstate"
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}
