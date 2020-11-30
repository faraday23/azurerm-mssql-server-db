#
# Required parameters
##

variable "location" {
  description = "Specifies the supported Azure location to SQL Server server resource"
  type        = string
}

variable "resource_group_name" {
  description = "name of the resource group to create the resource"
  type        = string
}

variable "names" {
  description = "names to be applied to resources"
  type        = map(string)
}

variable "tags" {
  description = "tags to be applied to resources"
  type        = map(string)
}

variable "sku_name" {
  description = "Azure database for SQL Server sku name"
  type        = string
  default     = "GP_Gen5_2"
}

variable "storage_mb" {
  description = "Max storage allowed for a server"
  type        = number
  default     = "10240"
}

variable "sql_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

variable "administrator_login" {
  type        = string
  description = "Database administrator login name"
  default     = "az_dbadmin"
}

variable "create_mode" {
  description = "Can be used to restore or replicate existing servers. Possible values are Default and Replica. Defaults to Default"
  type        = string
  default     = "Default"

  validation {
    condition     = var.create_mode == "Default" || var.create_mode == "Replica"
    error_message = "Create mode must be set to \"Default\" or \"Replica\"."
  }
}

variable "creation_source_server_name" {
  description = "the source server name to use. use this only when creating a read replica server"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "Specifies the number of days to keep in the Threat Detection audit logs"
  type        = number
  default     = 7
}

variable "ssl_enforcement_enabled" {
  description = "Specifies if SSL should be enforced on connections. Possible values are true and false."
  type        = bool
  default     = true
}

variable "infrastructure_encryption_enabled" {
  description = "Whether or not infrastructure is encrypted for this server. Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "auto_grow_enabled" {
  description = "Enable/Disable auto-growing of the storage."
  type        = bool
  default     = false
}

variable "service_endpoints" {
  description = "Creates a virtual network rule in the subnet_id (values are virtual network subnet ids)."
  type        = map(string)
  default     = {}
}

variable "access_list" {
  description = "Access list for SQL Server instance. Map off names to cidr ip start/end addresses"
  type = map(object({ start_ip_address = string,
  end_ip_address = string }))
  default = {}
}

variable "enable_active_directory_administrator" {
  description = "Set a user or group as the AD administrator for an SQL Server server in Azure"
  type        = bool
  default     = false
}

variable "ad_admin_login_name" {
  description = "The login name of the azure ad admin."
  type        = string
  default     = ""
}

variable "server_id" {
  description = "name of server applied to resources"
  type        = string
  default     = ""
}

variable "sa_storage_account" {
  description = "storage account for diagnostics module"
  type        = string
}

#variable "storage" {
#  description = "storage account options."
#  type        = string
#}

##
# Optional Parameters
##

variable "backup_retention_days" {
  description = "Backup retention days for the server, supported values are between 7 and 35 days."
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. When the backups are stored in geo-redundant backup storage, they are not only stored within the region in which your server is hosted, but are also replicated to a paired data center. This provides better protection and ability to restore your server in a different region in the event of a disaster. This is not supported for the Basic tier."
  type        = bool
  default     = false
}

variable "enable_threat_detection_policy" {
  description = "Threat detection policy configuration, known in the API as Server Security Alerts Policy."
  type        = bool
  default     = false
}

##
# Required SQL Server Server Parameters
##

variable "audit_log_enabled" {
  description = "Whether to enable auditing of logs."
  type        = bool
  default     = true
}

variable "max_allowed_packet" {
  type        = string
  description = "The maximum size of one packet or any generated/intermediate string, or any parameter sent by the sql_stmt_send_long_data() C API function."
  default     = "1073741824"
}

variable "max_connections" {
  type        = number
  description = "The maximum permitted number of simultaneous client connections. value 10-600"
  default     = 600
}

variable "max_heap_table_size" {
  type        = string
  description = "This variable sets the maximum size to which user-created MEMORY tables are permitted to grow."
  default     = "64000000"
}

variable "performance_schema" {
  type        = string
  description = "The value of this variable is ON or OFF to indicate whether the Performance Schema is enabled."
  default     = "ON"
}

variable "replicate_wild_ignore_table" {
  type        = string
  description = "Creates a replication filter which keeps the slave thread from replicating a statement in which any table matches the given wildcard pattern. To specify more than one table to ignore, use comma-separated list."
  default     = "sql.%,tempdb.%"
}

variable "slow_query_log" {
  type        = string
  description = "Enable or disable the slow query log"
  default     = "OFF"
}

variable "sort_buffer_size" {
  type        = number
  description = "Each session that must perform a sort allocates a buffer of this size."
  default     = 2000000
}

variable "tmp_table_size" {
  type        = number
  description = "The maximum size of internal in-memory temporary tables. This variable does not apply to user-created MEMORY tables."
  default     = 64000000
}

variable "transaction_isolation" {
  type        = string
  description = "The default transaction isolation level."
  default     = "READ-COMMITTED"
}

variable "query_store_capture_interval" {
  type        = string
  description = "The query store capture interval in minutes. Allows to specify the interval in which the query metrics are aggregated."
  default     = "15"
}

variable "query_store_capture_mode" {
  type        = string
  description = "The query store capture mode, NONE means do not capture any statements. NOTE: If performance_schema is OFF, turning on query_store_capture_mode will turn on performance_schema and a subset of performance schema instruments required for this feature."
  default     = "ALL"
}

variable "query_store_capture_utility_queries" {
  type        = string
  description = "Turning ON or OFF to capture all the utility queries that is executing in the system."
  default     = "YES"
}

variable "query_store_retention_period_in_days" {
  type        = number
  description = "The query store capture interval in minutes. Allows to specify the interval in which the query metrics are aggregated."
  default     = 7
}

variable "query_store_wait_sampling_capture_mode" {
  type        = string
  description = "The query store wait event sampling capture mode, NONE means do not capture any wait events."
  default     = "ALL"
}

variable "query_store_wait_sampling_frequency" {
  type        = number
  description = "The query store wait event sampling frequency in seconds."
  default     = 30
}

variable "databases" {
  description = "Map of databases to create (keys are database names). Allowed values are the same as for database_defaults."
  type        = map(any)
  default     = {}
}

variable "database_defaults" {
  description = "database default charset and collation (only applied to databases managed within this module)"
  type = object({
    collation          = string
    license_type       = string
    sku_name           = string
    max_size_gb        = number
    zone_redundant     = bool
    read_scale         = bool
    read_replica_count = number
  })
  default = {
    collation                   = "SQL_Latin1_General_CP1_CI_AS"
    license_type                = "LicenseIncluded"
    sku_name                    = "GP_S_Gen5_1"
    min_capacity                = 0.5
    auto_pause_delay_in_minutes = -1
    max_size_gb                 = 4
    zone_redundant              = false
    read_scale                  = false
    read_replica_count          = 0
  }
}

locals {
  databases = zipmap(keys(var.databases), [for database in values(var.databases) : merge(var.database_defaults, database)])
}

# Diagnostic settings

variable "automatic_tuning" {
  description = "Retention only applies to storage account. Retention policy ranges from 1 to 365 days. If you do not want to apply any retention policy and retain data forever, set retention (days) to 0."
  type        = number
}

variable "database_wait_statistics" {
  description = "Retention only applies to storage account. Retention policy ranges from 1 to 365 days. If you do not want to apply any retention policy and retain data forever, set retention (days) to 0."
  type        = number
}

variable "query_store_runtime_statistics" {
  description = "Retention only applies to storage account. Retention policy ranges from 1 to 365 days. If you do not want to apply any retention policy and retain data forever, set retention (days) to 0."
  type        = number
}

variable "query_store_wait_statistics" {
  description = "Retention only applies to storage account. Retention policy ranges from 1 to 365 days. If you do not want to apply any retention policy and retain data forever, set retention (days) to 0."
  type        = number
}

variable "error_log" {
  description = "Retention only applies to storage account. Retention policy ranges from 1 to 365 days. If you do not want to apply any retention policy and retain data forever, set retention (days) to 0."
  type        = number
}

variable "sql_insights" {
  description = "Retention only applies to storage account. Retention policy ranges from 1 to 365 days. If you do not want to apply any retention policy and retain data forever, set retention (days) to 0."
  type        = number
}

variable "deadlocks" {
  description = "Retention only applies to storage account. Retention policy ranges from 1 to 365 days. If you do not want to apply any retention policy and retain data forever, set retention (days) to 0."
  type        = number
}

variable "timeouts" {
  description = "Retention only applies to storage account. Retention policy ranges from 1 to 365 days. If you do not want to apply any retention policy and retain data forever, set retention (days) to 0."
  type        = number
}

variable "metric" {
  description = "Retention only applies to storage account. Retention policy ranges from 1 to 365 days. If you do not want to apply any retention policy and retain data forever, set retention (days) to 0."
  type        = number
}

variable "blocks" {
  description = "Retention only applies to storage account. Retention policy ranges from 1 to 365 days. If you do not want to apply any retention policy and retain data forever, set retention (days) to 0."
  type        = number
}


