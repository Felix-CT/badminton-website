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
  description = "Repository URL configured on the Amplify app."
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
  description = "Amplify branch that serves production."
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
  description = "Framework configured on the Amplify branch."
  type        = string
  default     = null
  nullable    = true
}

variable "amplify_branch_stage" {
  description = "Stage configured on the Amplify branch."
  type        = string
  default     = null
  nullable    = true
}

variable "amplify_domain_name" {
  description = "Custom domain connected to the production Amplify app."
  type        = string
  default     = null
  nullable    = true
}

variable "amplify_subdomains" {
  description = "Subdomain mappings for the Amplify domain association."
  type = map(object({
    branch_name = string
    prefix      = string
  }))
  default = {}
}
