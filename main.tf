locals {
  region_list    = ["eastus", "westus", "eastus2", "centralus", "westus2", "westcentralus", "australiaeast", "australiasoutheast", "southeastasia", "eastasia", "northeurope", "westeurope", "uksouth", "ukwest", "southafricanorth", "southafricawest", "centralindia", "southindia", "japaneast", "japanwest", "koreacentral", "koreasouth", "canadacentral", "canadaeast", "francecentral", "francesouth", "germanywestcentral", "germanynorth", "norwayeast", "norwaywest", "switzerlandnorth", "switzerlandwest", "uaenorth", "uaecentral", "southcentralus", "centraluseuap", "brazilsoutheast", "brazilsouth"]
  paired_regions = { for pair in chunklist(concat(local.region_list, reverse(local.region_list)), 2) : pair[0] => pair[1] }

  secondary_region = local.paired_regions[lower(replace(var.location, " ", ""))]
  replica_enabled  = var.create_mode == "Replica"
}

resource "random_string" "random" {
  length  = 24
  upper   = false
  special = false
}

resource "azurerm_storage_account" "sa" {
  name                     = random_string.random.result
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = local.replica_enabled ? "GZRS" : "LRS"
}

module "server" {
  count  = local.replica_enabled ? 2 : 1
  source = "./modules/server"

  suffix              = count.index + 1
  location            = count.index == 0 ? var.location : local.secondary_region
  resource_group_name = var.resource_group_name
  names               = var.names
  tags                = var.tags

  administrator_login = var.administrator_login
  ad_admin_login_name = var.ad_admin_login_name

  enable_extended_auditing_policy       = var.audit_log_enabled && count.index == 0
  enable_threat_detection_policy        = var.enable_threat_detection_policy && count.index == 0
  enable_active_directory_administrator = var.enable_active_directory_administrator

  log_retention_days = var.log_retention_days
  service_endpoints  = count.index == 0 ? var.service_endpoints : {}
  access_list        = count.index == 0 ? var.access_list : {}

  storage = {
    endpoint     = azurerm_storage_account.sa["${count.index == 0 ? "primary" : "secondary"}_blob_endpoint"]
    access_key   = azurerm_storage_account.sa["${count.index == 0 ? "primary" : "secondary"}_access_key"]
    is_secondary = count.index == 1
  }
}

# SQL Server Database within a SQL Server Server
module "db" {
  for_each           = local.databases
  source             = "./modules/db"
  name               = each.key
  server_id          = module.server[0].id
  collation          = each.value.collation
  license_type       = each.value.license_type
  sku_name           = each.value.sku_name
  max_size_gb        = each.value.max_size_gb
  zone_redundant     = each.value.zone_redundant
  read_scale         = each.value.read_scale
  read_replica_count = each.value.read_replica_count
  storage_account_resource_group = var.resource_group_name

  audit_log_enabled = var.audit_log_enabled

  log_retention_days = var.log_retention_days
  storage   = { endpoint = azurerm_storage_account.sa.primary_blob_endpoint, access_key = azurerm_storage_account.sa.primary_access_key }
  storage_endpoint   = var.storage.endpoint
  #diagnostic log settings
  automatic_tuning               = var.automatic_tuning
  blocks                         = var.blocks
  database_wait_statistics       = var.database_wait_statistics
  deadlocks                      = var.deadlocks
  error_log                      = var.error_log
  timeouts                       = var.timeouts
  query_store_runtime_statistics = var.query_store_runtime_statistics
  query_store_wait_statistics    = var.query_store_wait_statistics
  sql_insights                   = var.sql_insights
  metric                         = var.metric
}

# Azure SQL Failover Group - Default is "false" 
resource "azurerm_sql_failover_group" "fog" {
  count               = local.replica_enabled ? 1 : 0
  name                = "${var.names.product_name}-${var.names.environment}-failover-group"
  resource_group_name = var.resource_group_name
  server_name         = module.server[0].name
  databases           = [for db in values(module.db) : db.id]
  tags                = var.tags
  partner_servers {
    id = module.server[1].id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }

  readonly_endpoint_failover_policy {
    mode = "Enabled"
  }
}
