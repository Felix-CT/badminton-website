module "dns" {
  source = "./modules/dns"

  route53_zone_id   = var.route53_zone_id
  route53_zone_name = var.route53_zone_name
  route53_records   = var.route53_records
}

module "hosting" {
  source = "./modules/hosting"

  amplify_app_id                    = var.amplify_app_id
  amplify_app_name                  = var.amplify_app_name
  amplify_repository                = var.amplify_repository
  amplify_app_environment_variables = var.amplify_app_environment_variables
  amplify_custom_rules              = var.amplify_custom_rules
  amplify_branch_name               = var.amplify_branch_name
  amplify_branch_environment_variables = var.amplify_branch_environment_variables
  amplify_branch_framework          = var.amplify_branch_framework
  amplify_branch_stage              = var.amplify_branch_stage
  amplify_domain_name               = var.amplify_domain_name
  amplify_subdomains                = var.amplify_subdomains
}

module "iam" {
  source = "./modules/iam"

  iam_role_names          = var.iam_role_names
  iam_managed_policy_arns = var.iam_managed_policy_arns
  iam_roles               = var.iam_roles
}

module "data" {
  source = "./modules/data"

  dynamodb_table_names = var.dynamodb_table_names
  dynamodb_tables      = var.dynamodb_tables
}

module "api" {
  source = "./modules/api"

  aws_region                         = var.aws_region
  api_gateway_id                     = var.api_gateway_id
  api_gateway_name                   = var.api_gateway_name
  api_gateway_root_resource_id       = var.api_gateway_root_resource_id
  api_gateway_disable_execute_api_endpoint = var.api_gateway_disable_execute_api_endpoint
  api_gateway_endpoint_types         = var.api_gateway_endpoint_types
  api_gateway_stage_name             = var.api_gateway_stage_name
  api_gateway_stage_deployment_id    = var.api_gateway_stage_deployment_id
  api_gateway_stage_cache_cluster_enabled = var.api_gateway_stage_cache_cluster_enabled
  api_gateway_stage_cache_cluster_size = var.api_gateway_stage_cache_cluster_size
  api_gateway_stage_tracing_enabled  = var.api_gateway_stage_tracing_enabled
  api_gateway_root_methods           = var.api_gateway_root_methods
  lambda_function_names              = var.lambda_function_names
  lambda_functions                   = var.lambda_functions
  scheduler_schedules                = var.scheduler_schedules
}
