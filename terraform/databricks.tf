resource "azurerm_databricks_workspace" "dbk" {
  name                        = "${var.environment}-${var.project}-dbk"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  managed_resource_group_name = "${var.environment}-${var.project}-rg-dbk"
  sku                         = "standard"
  tags                        = var.tags
}

data "databricks_spark_version" "latest_lts" {
  latest            = true
  long_term_support = true
  depends_on        = [azurerm_databricks_workspace.dbk]
}

data "databricks_node_type" "node_type" {
  depends_on = [azurerm_databricks_workspace.dbk]
}


resource "databricks_instance_pool" "pool" {
  instance_pool_name                    = "${var.environment}-${var.project}-pool"
  min_idle_instances                    = 0
  max_capacity                          = 30
  node_type_id                          = data.databricks_node_type.node_type.id
  preloaded_spark_versions              = [data.databricks_spark_version.latest_lts.id]
  idle_instance_autotermination_minutes = 15
  azure_attributes {
    #availability = "SPOT_AZURE"
    availability = "ON_DEMAND_AZURE"
  }
}