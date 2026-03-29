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
  description = "Expected DNS records for the production zone."
  type = map(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = {}
}
