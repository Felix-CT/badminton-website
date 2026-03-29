output "inventory" {
  description = "Known IAM roles and managed policies for production."
  value       = local.inventory
}

output "role_resource_addresses" {
  description = "Terraform addresses for managed IAM roles."
  value = {
    for key, role in aws_iam_role.this :
    key => "module.iam.aws_iam_role.this[\"${key}\"]"
  }
}

output "policy_attachment_resource_addresses" {
  description = "Terraform addresses for managed IAM role policy attachments."
  value = {
    for key, attachment in aws_iam_role_policy_attachment.this :
    key => "module.iam.aws_iam_role_policy_attachment.this[\"${key}\"]"
  }
}
