resource "aws_dynamodb_table" "this" {
  for_each = var.dynamodb_tables

  name                        = each.key
  hash_key                    = each.value.hash_key
  range_key                   = try(each.value.range_key, null)
  billing_mode                = each.value.billing_mode
  read_capacity               = each.value.billing_mode == "PROVISIONED" ? each.value.read_capacity : null
  write_capacity              = each.value.billing_mode == "PROVISIONED" ? each.value.write_capacity : null
  deletion_protection_enabled = each.value.deletion_protection_enabled
  table_class                 = each.value.table_class

  dynamic "attribute" {
    for_each = each.value.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  lifecycle {
    ignore_changes  = [tags, tags_all]
    prevent_destroy = true
  }
}

locals {
  inventory = {
    dynamodb_table_names = sort(tolist(var.dynamodb_table_names))
    managed_table_keys   = sort(keys(var.dynamodb_tables))
  }
}
