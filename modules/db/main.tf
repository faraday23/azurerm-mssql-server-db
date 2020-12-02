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

# resource "azurerm_mssql_database_extended_auditing_policy" "db" {
#   count                      = var.audit_log_enabled ? 1 : 0
#   database_id                = azurerm_mssql_database.db.id
#   storage_endpoint           = var.storage.endpoint
#   storage_account_access_key = var.storage.access_key
#   retention_in_days          = var.log_retention_days
# }
