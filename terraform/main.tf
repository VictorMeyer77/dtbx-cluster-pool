terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.52.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.97.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.deploy_client_id
  client_secret   = var.deploy_client_secret
  tenant_id       = var.tenant_id
}


provider "databricks" {
  host                        = azurerm_databricks_workspace.dbk.workspace_url
  azure_workspace_resource_id = azurerm_databricks_workspace.dbk.id
  azure_client_id             = var.deploy_client_id
  azure_client_secret         = var.deploy_client_secret
  azure_tenant_id             = var.tenant_id
}


resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.project}-rg"
  location = var.resource_group_location
  tags     = var.tags
}