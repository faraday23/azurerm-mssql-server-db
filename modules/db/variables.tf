#######
# Name 
#######
variable "name" {
  description = "The name of the Ms SQL Database. Changing this forces a new resource to be created."
  type        = string
}

############
# Server Id 
############
variable "server_id" {
  description = "The id of the Ms SQL Server on which to create the database. Changing this forces a new resource to be created."
  type        = string
}

#######
# Flags
#######

# Audit Log Enabled 
variable "audit_log_enabled" {
  description = "The audit log enabled of the resource."
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "Specifies the number of days to keep in the Threat Detection audit logs"
  type        = number
  default     = 7
}


##########
# Storage 
##########
variable "storage" {
  description = "Specifies the identifier key of the Threat Detection audit storage account. Required if retention is Enabled."
  type        = object({ endpoint = string, access_key = string })

  default = { "endpoint" = "", "access_key" = "" }
}

variable "collation" {
  description = "Specifies the collation of the database. Changing this forces a new resource to be created."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}
variable "license_type" {
  description = "Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice."
  type        = string
  default     = "LicenseIncluded"
}
variable "sku_name" {
  description = "Specifies the name of the sku used by the database. Changing this forces a new resource to be created. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100."
  type        = string
  default     = "GP_S_Gen5_1"

  validation {
    condition     = can(regex("GP_S_Gen5_1|GP_S_Gen5_2|HS_Gen4_1|BC_Gen5_2|ElasticPool|Basic|S0|P2|DW100c|DS100", var.sku_name))
    error_message = "Sku name invalid. Must be GP_S_Gen5_1,GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100."
  }
}
variable "min_capacity" {
  type    = number
  default = 0.5
}
variable "auto_pause_delay_in_minutes" {
  type    = number
  default = -1
}
variable "max_size_gb" {
  type    = number
  default = 4
}
variable "zone_redundant" {
  type    = bool
  default = false
}
variable "read_scale" {
  type    = bool
  default = false
}
variable "read_replica_count" {
  type    = number
  default = 0
}
