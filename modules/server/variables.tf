##
# Required parameters
##

variable "location" {
  description = "Specifies the supported Azure location to SQL Server server resource"
  type        = string
}

variable "suffix" {
  description = "The suffix of the resource."
  type        = number
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

variable "server_id" {
  description = "name of server applied to resources"
  type        = string
}

##########
# Flags
##########
# Is Secondary
variable "is_secondary"  {
  description = "The is secondary of the resource."
  type        = bool
  default     = false
}

variable "enable_extended_auditing_policy" {
  description = "Whether to enable auditing of logs."
  type        = bool
  default     = true
}

variable "enable_threat_detection_policy" {
  description = "Threat detection policy configuration, known in the API as Server Security Alerts Policy."
  type        = bool
  default     = false
}

variable "enable_active_directory_administrator" {
  description = "The active directory administrator of the resource."
  type        = bool
  default     = false
}

##########
# Optional 
##########

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

variable "ad_admin_login_name" {
  description = "The login name of the azure ad admin."
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "Specifies the number of days to keep in the Threat Detection audit logs"
  type        = number
  default     = 7
}

variable "storage" {
  description = "Specifies the identifier key of the Threat Detection audit storage account. Required if retention is Enabled."
  type        = object({ endpoint = string, access_key = string, is_secondary = bool })

  default = { "endpoint" = "", "access_key" = "", "is_secondary" = false }
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
