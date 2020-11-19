output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = var.resource_group_name
}

output "administrator_login" {
  description = "The sql instance login for the admin."
  sensitive   = true
  value       = var.administrator_login
}

output "administrator_password" {
  description = "The password for the admin account of the MySQL instance."
  sensitive   = true
  value       = module.server[0].administrator_password
}

output "name" {
  description = "The Name of the sql instance."
  value       = module.server[0].name
}

output "id" {
  description = "The ID of the MySQL instance."
  value       = module.server[0].id
}

output "fqdn" {
  description = "The fully qualified domain name of the Azure MySQL Server"
  value       = module.server[0].fqdn
}

output "database_ids" {
  description = "The resulting database ids"
  value       = { for key, db in module.db : key => { id = db.id } }
}
