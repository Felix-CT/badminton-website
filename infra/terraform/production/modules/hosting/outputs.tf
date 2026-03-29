output "inventory" {
  description = "Known Amplify identifiers for production hosting."
  value       = local.inventory
}

output "app_resource_address" {
  description = "Terraform address for the managed Amplify app when enabled."
  value       = length(aws_amplify_app.this) == 0 ? null : "module.hosting.aws_amplify_app.this[0]"
}

output "branch_resource_address" {
  description = "Terraform address for the managed Amplify branch when enabled."
  value       = length(aws_amplify_branch.this) == 0 ? null : "module.hosting.aws_amplify_branch.this[0]"
}

output "domain_resource_address" {
  description = "Terraform address for the managed Amplify domain association when enabled."
  value       = length(aws_amplify_domain_association.this) == 0 ? null : "module.hosting.aws_amplify_domain_association.this[0]"
}
