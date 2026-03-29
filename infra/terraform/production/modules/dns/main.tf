resource "aws_route53_zone" "this" {
  count = var.route53_zone_id != null && var.route53_zone_name != null ? 1 : 0

  name = var.route53_zone_name
  force_destroy = false

  lifecycle {
    ignore_changes  = [comment, force_destroy, tags, tags_all]
    prevent_destroy = true
  }
}

resource "aws_route53_record" "this" {
  for_each = var.route53_zone_id != null ? var.route53_records : {}

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records

  allow_overwrite = false
}

locals {
  inventory = {
    route53_zone_id      = var.route53_zone_id
    route53_zone_name    = var.route53_zone_name
    route53_records      = var.route53_records
    managed_zone_enabled = var.route53_zone_id != null && var.route53_zone_name != null
    managed_record_keys  = sort(keys(var.route53_records))
  }
}
