variable "project_name" {
  description = "Project name used in tags and state layout."
  type        = string
  default     = "badminton-website"
}

variable "environment" {
  description = "Deployment environment managed by this root."
  type        = string
  default     = "production"
}

variable "aws_region" {
  description = "Primary AWS region for the production stack."
  type        = string
  default     = "us-east-2"
}

variable "additional_tags" {
  description = "Additional default tags applied to managed resources."
  type        = map(string)
  default     = {}
}

variable "route53_zone_id" {
  description = "Hosted zone ID for the production domain."
  type        = string
  default     = null
  nullable    = true
}

variable "route53_zone_name" {
  description = "Hosted zone name for the production domain."
  type        = string
  default     = null
  nullable    = true
}

variable "route53_records" {
  description = "Map of Route53 records expected to exist in production."
  type = map(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = {}
}

variable "amplify_app_id" {
  description = "Amplify application ID for the production website."
  type        = string
  default     = null
  nullable    = true
}

variable "amplify_app_name" {
  description = "Amplify application name required to import the app resource."
  type        = string
  default     = null
  nullable    = true
}

variable "amplify_repository" {
  description = "Repository URL connected to the Amplify app."
  type        = string
  default     = null
  nullable    = true
}

variable "amplify_app_environment_variables" {
  description = "Environment variables configured on the Amplify app."
  type        = map(string)
  default     = {}
}

variable "amplify_custom_rules" {
  description = "Custom redirect and rewrite rules configured on the Amplify app."
  type = list(object({
    source    = string
    target    = string
    status    = string
    condition = optional(string)
  }))
  default = []
}

variable "amplify_branch_name" {
  description = "Amplify branch wired to production hosting."
  type        = string
  default     = null
  nullable    = true
}

variable "amplify_branch_environment_variables" {
  description = "Environment variables configured on the Amplify branch."
  type        = map(string)
  default     = {}
}

variable "amplify_branch_framework" {
  description = "Framework value configured on the Amplify branch."
  type        = string
  default     = null
  nullable    = true
}

variable "amplify_branch_stage" {
  description = "Stage value configured on the Amplify branch."
  type        = string
  default     = null
  nullable    = true
}

variable "amplify_domain_name" {
  description = "Custom domain associated with the production Amplify app."
  type        = string
  default     = null
  nullable    = true
}

variable "amplify_subdomains" {
  description = "Amplify domain association subdomains keyed by a stable name."
  type = map(object({
    branch_name = string
    prefix      = string
  }))
  default = {}
}

variable "api_gateway_id" {
  description = "REST API ID currently used by the guest-management frontend."
  type        = string
  default     = null
  nullable    = true
}

variable "api_gateway_name" {
  description = "REST API name for the production guest-management API."
  type        = string
  default     = null
  nullable    = true
}

variable "api_gateway_root_resource_id" {
  description = "Root resource ID for the REST API."
  type        = string
  default     = null
  nullable    = true
}

variable "api_gateway_disable_execute_api_endpoint" {
  description = "Whether the execute-api endpoint is disabled on the REST API."
  type        = bool
  default     = false
}

variable "api_gateway_endpoint_types" {
  description = "Endpoint configuration types for the REST API."
  type        = list(string)
  default     = ["REGIONAL"]
}

variable "api_gateway_stage_name" {
  description = "REST API stage currently used by the frontend."
  type        = string
  default     = null
  nullable    = true
}

variable "api_gateway_stage_deployment_id" {
  description = "Existing deployment ID currently targeted by the production stage."
  type        = string
  default     = null
  nullable    = true
}

variable "api_gateway_stage_cache_cluster_enabled" {
  description = "Whether the API Gateway stage cache cluster is enabled."
  type        = bool
  default     = false
}

variable "api_gateway_stage_cache_cluster_size" {
  description = "Cache cluster size configured on the API Gateway stage when enabled."
  type        = string
  default     = null
  nullable    = true
}

variable "api_gateway_stage_tracing_enabled" {
  description = "Whether X-Ray tracing is enabled on the API Gateway stage."
  type        = bool
  default     = false
}

variable "api_gateway_root_methods" {
  description = "Root resource method and integration definitions keyed by HTTP method."
  type = map(object({
    authorization    = string
    api_key_required = bool
    request_parameters = map(bool)
    request_models     = map(string)
    method_responses = map(object({
      response_parameters = map(bool)
      response_models     = map(string)
    }))
    integration = object({
      type                 = string
      http_method          = optional(string)
      uri                  = optional(string)
      passthrough_behavior = optional(string)
      content_handling     = optional(string)
      timeout_milliseconds = optional(number)
      request_templates    = map(string)
      integration_responses = map(object({
        response_parameters = map(string)
        response_templates  = map(string)
      }))
    })
  }))
  default = {}
}

variable "lambda_function_names" {
  description = "Lambda functions behind the production guest-management API."
  type        = set(string)
  default     = []
}

variable "lambda_functions" {
  description = "Discovered Lambda function definitions keyed by function name."
  type = map(object({
    description            = optional(string)
    role_arn               = string
    handler                = string
    runtime                = string
    timeout                = number
    memory_size            = number
    package_type           = string
    architectures          = list(string)
    ephemeral_storage_size = number
    filename               = string
    log_group_name         = string
  }))
  default = {}
}

variable "dynamodb_table_names" {
  description = "DynamoDB tables used by the production backend."
  type        = set(string)
  default     = []
}

variable "dynamodb_tables" {
  description = "Discovered DynamoDB table definitions keyed by table name."
  type = map(object({
    hash_key                    = string
    range_key                   = optional(string)
    billing_mode                = string
    read_capacity               = optional(number)
    write_capacity              = optional(number)
    deletion_protection_enabled = bool
    table_class                 = string
    attributes = list(object({
      name = string
      type = string
    }))
  }))
  default = {}
}

variable "iam_role_names" {
  description = "IAM roles owned by the production backend."
  type        = set(string)
  default     = []
}

variable "iam_managed_policy_arns" {
  description = "Managed policy ARNs attached to production IAM roles."
  type        = set(string)
  default     = []
}

variable "iam_roles" {
  description = "Discovered IAM role definitions keyed by role name."
  type = map(object({
    path                 = string
    description          = optional(string)
    max_session_duration = number
    assume_role_policy   = string
    managed_policy_arns  = set(string)
  }))
  default = {}
}

variable "scheduler_schedules" {
  description = "EventBridge Scheduler schedules keyed by schedule name."
  type = map(object({
    group_name                   = string
    description                  = optional(string)
    schedule_expression          = string
    schedule_expression_timezone = string
    state                        = string
    flexible_time_window_mode    = string
    target_arn                   = string
    target_role_arn              = string
    target_input                 = optional(string)
    retry_max_event_age          = number
    retry_max_attempts           = number
  }))
  default = {}
}
