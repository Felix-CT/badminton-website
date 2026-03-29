resource "aws_lambda_function" "this" {
  for_each = var.lambda_functions

  function_name = each.key
  description   = try(each.value.description, null)
  role          = each.value.role_arn
  package_type  = each.value.package_type
  publish       = false
  filename      = each.value.filename
  handler       = each.value.package_type == "Zip" ? each.value.handler : null
  runtime       = each.value.package_type == "Zip" ? each.value.runtime : null
  timeout       = each.value.timeout
  memory_size   = each.value.memory_size
  architectures = each.value.architectures

  source_code_hash = can(filebase64sha256(each.value.filename)) ? filebase64sha256(each.value.filename) : null

  ephemeral_storage {
    size = each.value.ephemeral_storage_size
  }

  lifecycle {
    ignore_changes  = [filename, publish, source_code_hash, tags, tags_all]
    prevent_destroy = true
  }
}

resource "aws_api_gateway_rest_api" "this" {
  count = var.api_gateway_id != null && var.api_gateway_name != null ? 1 : 0

  name                        = var.api_gateway_name
  api_key_source              = "HEADER"
  disable_execute_api_endpoint = var.api_gateway_disable_execute_api_endpoint

  endpoint_configuration {
    types = var.api_gateway_endpoint_types
  }

  lifecycle {
    ignore_changes  = [tags, tags_all]
    prevent_destroy = true
  }
}

locals {
  manage_rest_api     = var.api_gateway_id != null && var.api_gateway_name != null
  manage_api_methods  = local.manage_rest_api && var.api_gateway_root_resource_id != null
}

resource "aws_api_gateway_method" "root" {
  for_each = local.manage_api_methods ? var.api_gateway_root_methods : {}

  rest_api_id      = var.api_gateway_id
  resource_id      = var.api_gateway_root_resource_id
  http_method      = each.key
  authorization    = each.value.authorization
  api_key_required = each.value.api_key_required
  request_parameters = each.value.request_parameters
  request_models     = each.value.request_models
}

resource "aws_api_gateway_integration" "root" {
  for_each = local.manage_api_methods ? var.api_gateway_root_methods : {}

  rest_api_id             = var.api_gateway_id
  resource_id             = var.api_gateway_root_resource_id
  http_method             = each.key
  type                    = var.api_gateway_root_methods[each.key].integration.type
  integration_http_method = try(var.api_gateway_root_methods[each.key].integration.http_method, null)
  uri                     = try(var.api_gateway_root_methods[each.key].integration.uri, null)
  passthrough_behavior    = try(var.api_gateway_root_methods[each.key].integration.passthrough_behavior, null)
  content_handling        = try(var.api_gateway_root_methods[each.key].integration.content_handling, null)
  timeout_milliseconds    = try(var.api_gateway_root_methods[each.key].integration.timeout_milliseconds, null)
  request_templates       = var.api_gateway_root_methods[each.key].integration.request_templates
}

locals {
  method_responses = {
    for item in flatten([
      for http_method, method in var.api_gateway_root_methods : [
        for status_code, response in method.method_responses : {
          key         = "${http_method}_${status_code}"
          http_method = http_method
          status_code = status_code
          response    = response
        }
      ]
    ]) :
    item.key => item
  }

  integration_responses = {
    for item in flatten([
      for http_method, method in var.api_gateway_root_methods : [
        for status_code, response in method.integration.integration_responses : {
          key         = "${http_method}_${status_code}"
          http_method = http_method
          status_code = status_code
          response    = response
        }
      ]
    ]) :
    item.key => item
  }
}

resource "aws_api_gateway_method_response" "root" {
  for_each = local.manage_api_methods ? local.method_responses : {}

  rest_api_id         = var.api_gateway_id
  resource_id         = var.api_gateway_root_resource_id
  http_method         = each.value.http_method
  status_code         = each.value.status_code
  response_parameters = each.value.response.response_parameters
  response_models     = each.value.response.response_models
}

resource "aws_api_gateway_integration_response" "root" {
  for_each = local.manage_api_methods ? local.integration_responses : {}

  rest_api_id         = var.api_gateway_id
  resource_id         = var.api_gateway_root_resource_id
  http_method         = each.value.http_method
  status_code         = each.value.status_code
  response_parameters = each.value.response.response_parameters
  response_templates  = each.value.response.response_templates

  depends_on = [aws_api_gateway_integration.root, aws_api_gateway_method_response.root]
}

resource "aws_api_gateway_stage" "this" {
  count = local.manage_rest_api && var.api_gateway_stage_deployment_id != null ? 1 : 0

  rest_api_id           = var.api_gateway_id
  stage_name            = var.api_gateway_stage_name
  deployment_id         = var.api_gateway_stage_deployment_id
  cache_cluster_enabled = var.api_gateway_stage_cache_cluster_enabled
  cache_cluster_size    = var.api_gateway_stage_cache_cluster_enabled ? var.api_gateway_stage_cache_cluster_size : null
  xray_tracing_enabled  = var.api_gateway_stage_tracing_enabled

  lifecycle {
    ignore_changes  = [tags, tags_all]
    prevent_destroy = true
  }
}

resource "aws_scheduler_schedule" "this" {
  for_each = var.scheduler_schedules

  name                         = each.key
  group_name                   = each.value.group_name
  description                  = try(each.value.description, null)
  schedule_expression          = each.value.schedule_expression
  schedule_expression_timezone = each.value.schedule_expression_timezone
  state                        = each.value.state

  flexible_time_window {
    mode = each.value.flexible_time_window_mode
  }

  target {
    arn      = each.value.target_arn
    role_arn = each.value.target_role_arn
    input    = try(each.value.target_input, null)

    retry_policy {
      maximum_event_age_in_seconds = each.value.retry_max_event_age
      maximum_retry_attempts       = each.value.retry_max_attempts
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

locals {
  execute_api_base_url = var.api_gateway_id == null ? null : format(
    "https://%s.execute-api.%s.amazonaws.com/%s",
    var.api_gateway_id,
    var.aws_region,
    var.api_gateway_stage_name,
  )

  inventory = {
    api_gateway_id                        = var.api_gateway_id
    api_gateway_name                      = var.api_gateway_name
    api_gateway_root_resource_id          = var.api_gateway_root_resource_id
    api_gateway_stage_name                = var.api_gateway_stage_name
    api_gateway_stage_deployment_id       = var.api_gateway_stage_deployment_id
    api_gateway_root_methods              = sort(keys(var.api_gateway_root_methods))
    execute_api_base_url                  = local.execute_api_base_url
    lambda_function_names                 = sort(tolist(var.lambda_function_names))
    managed_lambda_keys                   = sort(keys(var.lambda_functions))
    lambda_log_group_names                = {
      for key, function in var.lambda_functions :
      key => function.log_group_name
    }
    managed_scheduler_keys                = sort(keys(var.scheduler_schedules))
  }
}
