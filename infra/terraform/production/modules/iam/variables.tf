variable "iam_role_names" {
  description = "IAM roles required by the production backend."
  type        = set(string)
  default     = []
}

variable "iam_managed_policy_arns" {
  description = "Managed policy ARNs attached to production IAM roles."
  type        = set(string)
  default     = []
}

variable "iam_roles" {
  description = "IAM role definitions keyed by role name."
  type = map(object({
    path                 = string
    description          = optional(string)
    max_session_duration = number
    assume_role_policy   = string
    managed_policy_arns  = set(string)
  }))
  default = {}
}
