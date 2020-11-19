output "name" {
  description = "The Name of the sql instance."
  value       = azurerm_mssql_server.instance.name
}

output "id" {
  description = "The ID of the MySQL instance."
  value       = azurerm_mssql_server.instance.id
}

output "fqdn" {
  description = "The fully qualified domain name of the Azure MySQL Server"
  value       = azurerm_mssql_server.instance.fully_qualified_domain_name
}

output "administrator_password" {
  description = "The password for the admin account of the MySQL instance."
  sensitive   = true
  value       = random_password.admin.result
}
