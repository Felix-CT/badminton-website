output "inventory" {
  description = "Known Route53 identifiers and expected records."
  value       = local.inventory
}

output "hosted_zone_resource_address" {
  description = "Terraform address for the managed hosted zone when enabled."
  value       = length(aws_route53_zone.this) == 0 ? null : "module.dns.aws_route53_zone.this[0]"
}

output "record_resource_addresses" {
  description = "Terraform addresses for managed Route53 record resources."
  value = {
    for key, record in aws_route53_record.this :
    key => "module.dns.aws_route53_record.this[\"${key}\"]"
  }
}
