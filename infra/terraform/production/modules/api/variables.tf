variable "aws_region" {
  description = "AWS region hosting the production REST API."
  type        = string
}

variable "api_gateway_id" {
  description = "REST API ID serving the guest-management frontend."
  type        = string
  default     = null
  nullable    = true
}

variable "api_gateway_name" {
  description = "REST API name serving the guest-management frontend."
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
  description = "Endpoint types configured on the REST API."
  type        = list(string)
  default     = ["REGIONAL"]
}

variable "api_gateway_stage_name" {
  description = "Stage name serving the production frontend."
  type        = string
  default     = null
  nullable    = true
}

variable "api_gateway_stage_deployment_id" {
  description = "Deployment ID currently targeted by the API Gateway stage."
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
  description = "Cache cluster size configured on the stage when enabled."
  type        = string
  default     = null
  nullable    = true
}

variable "api_gateway_stage_tracing_enabled" {
  description = "Whether X-Ray tracing is enabled on the stage."
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
  description = "Lambda functions invoked by the REST API."
  type        = set(string)
  default     = []
}

variable "lambda_functions" {
  description = "Lambda function definitions keyed by function name."
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
