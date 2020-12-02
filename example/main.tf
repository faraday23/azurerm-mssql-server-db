# Configure terraform and azure provider
terraform {
  required_version = ">= 0.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.25.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

data "azurerm_subscription" "current" {
}

resource "random_string" "random" {
  length  = 12
  upper   = false
  special = false
}

module "subscription" {
  source          = "github.com/Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
  subscription_id = "b0837458-adf3-41b0-a8fb-c16f9719627d"
}

#module "rules" {
#  source = "github.com/openrba/python-azure-naming.git?ref=tf"
#}

module "metadata" {
  source = "github.com/Azure-Terraform/terraform-azurerm-metadata.git?ref=v1.1.0"

  naming_rules = file("${path.module}/custom_rules.yaml")

  market              = "us"
  project             = "https://gitlab.ins.risk.regn.net/example/"
  location            = "useast2"
  sre_team            = "iog-core-services"
  environment         = "sandbox"
  product_name        = random_string.random.result
  business_unit       = "iog"
  product_group       = "core"
  subscription_id     = module.subscription.output.subscription_id
  subscription_type   = "nonprod"
  resource_group_type = "app"
}

module "resource_group" {
  source = "github.com/Azure-Terraform/terraform-azurerm-resource-group.git?ref=v1.0.0"

  location = module.metadata.location
  names    = module.metadata.names
  tags     = module.metadata.tags
}

# create storage account
module "create_storage_account" {
    depends_on = [module.resource_group]
    source = "github.com/faraday23/azurerm-storage-account.git"
    names                    = module.metadata.names
    location                 = module.metadata.location
    account_kind             = "BlobStorage"
    account_tier             = "Standard"
    replication_type         = "LRS"
    access_tier              = "Cool"
    allow_blob_public_access = false
    authorized_subnets       = {"my_ip" = chomp(data.http.my_ip.body)}
    tags                     = module.metadata.tags
    retention_days           = 7
}

module "mssql" {
  source = "../mssql-tf-docs/parent_module"

  names      = module.metadata.names
  tags       = module.metadata.tags
  location   = module.metadata.location

  databases = { "foo" = {}
  "bar" = { collation = "SQL_Latin1_General_CP1_CI_AS" } }

  resource_group_name = "rg-azure-demo-mssql-01"
  server_id           = random_string.random.result

  sa_storage_account = module.create_storage_account.storage_account_name

  # diagnostic settings
  enable_logs_to_storage = true

  # Diagnostic retention policy applies to storage account, ranges from 1 to 365 days. 
  # If you do not want to apply any retention policy comment the line out.
  automatic_tuning               = "90"
  blocks                         = "90"
  database_wait_statistics       = "90"
  query_store_runtime_statistics = "90"
  query_store_wait_statistics    = "90"
  error_log                      = "90"
  sql_insights                   = "90"
  deadlocks                      = "90"
  timeouts                       = "90"
  metric                         = "90"
}

output "resource_group" {
  value = module.resource_group.name
}

output "mssql_fqdn" {
  value = module.mssql.fqdn
}

output "mssql_admin_login" {
  value = module.mssql.administrator_login
}

output "mssql_admin_password" {
  value = module.mssql.administrator_password
}

output "mssql_test_command" {
  value = "mssql -h ${module.mssql.fqdn} -u ${module.mssql.administrator_login}@${module.mssql.name} -p${module.mssql.administrator_password}"
}

