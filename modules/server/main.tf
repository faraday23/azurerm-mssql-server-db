# creates random password for admin account
resource "random_password" "admin" {
  length  = 24
  special = true
}

resource "azurerm_mssql_server" "instance" {
  name                = "${var.names.product_name}-${var.names.environment}-sql${var.server_id}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  administrator_login          = var.administrator_login
  administrator_login_password = random_password.admin.result

  version = var.sql_version

  public_network_access_enabled = ((length(var.service_endpoints) + length(var.access_list) > 0) ? true : false)
  minimum_tls_version           = "1.2"
}

data "azurerm_client_config" "current" {}

# Adding AD Admin to SQL Server Server - Default is "false"
resource "azurerm_sql_active_directory_administrator" "ad_admin" {
  count               = var.enable_active_directory_administrator ? 1 : 0
  server_name         = azurerm_mssql_server.instance.name
  resource_group_name = var.resource_group_name
  login               = var.ad_admin_login_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}

# SQL Server Service Endpoints 
resource "azurerm_sql_virtual_network_rule" "service_endpoint" {
  for_each            = var.service_endpoints
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.instance.name
  subnet_id           = each.value
}

# SQL Server Access List
resource "azurerm_sql_firewall_rule" "access_list" {
  for_each            = var.access_list
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.instance.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
}


###
# Policies
###
#resource "azurerm_mssql_server_extended_auditing_policy" "auditing" {
#  count                                   = var.enable_extended_auditing_policy ? 1 : 0
#  server_id                               = azurerm_mssql_server.instance.id
#  storage_account_access_key              = var.storage_access_key
#  storage_account_access_key_is_secondary = var.is_secondary
#  retention_in_days                       = var.log_retention_days
#}

# SQL Server Security Alert Policy
#resource "azurerm_mssql_server_security_alert_policy" "alert" {
#  count                      = var.enable_threat_detection_policy ? 1 : 0
#  resource_group_name        = var.resource_group_name
#  server_name                = azurerm_mssql_server.instance.name
#  state                      = "Enabled"
#  storage_endpoint           = var.storage_endpoint
#  storage_account_access_key = var.storage_access_key
#  retention_days             = var.log_retention_days
#}
