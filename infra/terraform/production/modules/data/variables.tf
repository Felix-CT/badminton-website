variable "dynamodb_table_names" {
  description = "DynamoDB tables used by the production backend."
  type        = set(string)
  default     = []
}

variable "dynamodb_tables" {
  description = "DynamoDB table definitions keyed by table name."
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
