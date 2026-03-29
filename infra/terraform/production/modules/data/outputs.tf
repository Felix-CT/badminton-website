output "inventory" {
  description = "Known DynamoDB tables for the production backend."
  value       = local.inventory
}

output "table_resource_addresses" {
  description = "Terraform addresses for managed DynamoDB tables."
  value = {
    for key, table in aws_dynamodb_table.this :
    key => "module.data.aws_dynamodb_table.this[\"${key}\"]"
  }
}
