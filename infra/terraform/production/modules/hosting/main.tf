resource "aws_amplify_app" "this" {
  count = var.amplify_app_id != null && var.amplify_app_name != null ? 1 : 0

  name                  = var.amplify_app_name
  repository            = var.amplify_repository
  environment_variables = var.amplify_app_environment_variables

  dynamic "custom_rule" {
    for_each = var.amplify_custom_rules

    content {
      source    = custom_rule.value.source
      target    = custom_rule.value.target
      status    = custom_rule.value.status
      condition = try(custom_rule.value.condition, null)
    }
  }

  lifecycle {
    ignore_changes  = [tags, tags_all]
    prevent_destroy = true
  }
}

resource "aws_amplify_branch" "this" {
  count = var.amplify_app_id != null && var.amplify_branch_name != null ? 1 : 0

  app_id                = var.amplify_app_id
  branch_name           = var.amplify_branch_name
  environment_variables = var.amplify_branch_environment_variables
  framework             = var.amplify_branch_framework
  stage                 = var.amplify_branch_stage

  lifecycle {
    ignore_changes  = [tags, tags_all]
    prevent_destroy = true
  }
}

resource "aws_amplify_domain_association" "this" {
  count = var.amplify_app_id != null && var.amplify_domain_name != null && length(var.amplify_subdomains) > 0 ? 1 : 0

  app_id                = var.amplify_app_id
  domain_name           = var.amplify_domain_name
  wait_for_verification = false

  dynamic "sub_domain" {
    for_each = var.amplify_subdomains

    content {
      branch_name = sub_domain.value.branch_name
      prefix      = sub_domain.value.prefix
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

locals {
  inventory = {
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
    managed_app_enabled               = var.amplify_app_id != null && var.amplify_app_name != null
    managed_branch_enabled            = var.amplify_app_id != null && var.amplify_branch_name != null
    managed_domain_enabled            = var.amplify_app_id != null && var.amplify_domain_name != null && length(var.amplify_subdomains) > 0
    managed_subdomain_keys            = sort(keys(var.amplify_subdomains))
  }
}
