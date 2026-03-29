output "inventory" {
  description = "Known API Gateway and Lambda identifiers for production."
  value       = local.inventory
}

output "rest_api_resource_address" {
  description = "Terraform address for the managed REST API when enabled."
  value       = length(aws_api_gateway_rest_api.this) == 0 ? null : "module.api.aws_api_gateway_rest_api.this[0]"
}

output "method_resource_addresses" {
  description = "Terraform addresses for managed API Gateway methods."
  value = {
    for key, method in aws_api_gateway_method.root :
    key => "module.api.aws_api_gateway_method.root[\"${key}\"]"
  }
}

output "integration_resource_addresses" {
  description = "Terraform addresses for managed API Gateway integrations."
  value = {
    for key, integration in aws_api_gateway_integration.root :
    key => "module.api.aws_api_gateway_integration.root[\"${key}\"]"
  }
}

output "stage_resource_address" {
  description = "Terraform address for the managed API Gateway stage when enabled."
  value       = length(aws_api_gateway_stage.this) == 0 ? null : "module.api.aws_api_gateway_stage.this[0]"
}

output "lambda_resource_addresses" {
  description = "Terraform addresses for managed Lambda functions."
  value = {
    for key, function in aws_lambda_function.this :
    key => "module.api.aws_lambda_function.this[\"${key}\"]"
  }
}

output "scheduler_resource_addresses" {
  description = "Terraform addresses for managed EventBridge Scheduler schedules."
  value = {
    for key, schedule in aws_scheduler_schedule.this :
    key => "module.api.aws_scheduler_schedule.this[\"${key}\"]"
  }
}