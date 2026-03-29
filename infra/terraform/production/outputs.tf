output "default_tags" {
  description = "Default tags applied by the production AWS provider configuration."
  value       = local.default_tags
}

output "import_sequence" {
  description = "Recommended import order for the production brownfield migration."
  value = [
    "module.dns",
    "module.hosting",
    "module.iam",
    "module.data",
    "module.api",
  ]
}

output "dns_inventory" {
  description = "Known DNS identifiers collected for production."
  value       = module.dns.inventory
}

output "hosting_inventory" {
  description = "Known Amplify identifiers collected for production."
  value       = module.hosting.inventory
}

output "iam_inventory" {
  description = "Known IAM identifiers collected for production."
  value       = module.iam.inventory
}

output "data_inventory" {
  description = "Known DynamoDB identifiers collected for production."
  value       = module.data.inventory
}

output "api_inventory" {
  description = "Known API and Lambda identifiers collected for production."
  value       = module.api.inventory
}
