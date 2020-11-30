# SQL Server Database within a SQL Server Server
resource "azurerm_mssql_database" "db" {
  name               = var.name
  server_id          = var.server_id
  collation          = var.collation
  license_type       = var.license_type
  sku_name           = var.sku_name
  max_size_gb        = var.max_size_gb
  zone_redundant     = var.zone_redundant
  read_scale         = var.read_scale
  read_replica_count = var.read_replica_count

  auto_pause_delay_in_minutes = var.sku_name == "GP_S_Gen5_1" ? var.auto_pause_delay_in_minutes : 0
  min_capacity                = var.sku_name == "GP_S_Gen5_1" ? var.min_capacity : 0
}

# Diagnostic setting
module "diagnostic_mssql_db" {
  source                         = "github.com/faraday23/terraform-azurerm-monitor-diagnostic-setting.git"
  storage_account                = var.sa_storage_account
  sa_resource_group              = var.storage_account_resource_group
  target_resource_id             = azurerm_mssql_database.db.id
  target_resource_name           = azurerm_mssql_database.db.name
  ds_allmetrics_rentention_days  = var.metric
  
  ds_log_api_endpoints = { "AutomaticTuning" = var.automatic_tuning,
  "Blocks"                      = var.blocks,
  "DatabaseWaitStatistics"      = var.database_wait_statistics,
  "Deadlocks"                   = var.deadlocks,
  "Errors"                      = var.error_log, 
  "Timeouts"                    = var.timeouts,
  "QueryStoreRuntimeStatistics" = var.query_store_runtime_statistics
  "QueryStoreWaitStatistics"    = var.query_store_wait_statistics
  "SQLinsights"                 = var.sql_insights
  }
}

