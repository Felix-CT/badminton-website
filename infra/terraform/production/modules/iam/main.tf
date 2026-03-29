resource "aws_iam_role" "this" {
  for_each = var.iam_roles

  name                 = each.key
  path                 = each.value.path
  description          = try(each.value.description, null)
  max_session_duration = each.value.max_session_duration
  assume_role_policy   = each.value.assume_role_policy

  lifecycle {
    ignore_changes  = [tags, tags_all]
    prevent_destroy = true
  }
}

locals {
  managed_policy_attachments = {
    for attachment in flatten([
      for role_name, role in var.iam_roles : [
        for policy_arn in role.managed_policy_arns : {
          key        = "${role_name} ${policy_arn}"
          role_name  = role_name
          policy_arn = policy_arn
        }
      ]
    ]) :
    attachment.key => {
      role_name  = attachment.role_name
      policy_arn = attachment.policy_arn
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.managed_policy_attachments

  role       = aws_iam_role.this[each.value.role_name].name
  policy_arn = each.value.policy_arn
}

locals {
  inventory = {
    iam_role_names               = sort(tolist(var.iam_role_names))
    iam_managed_policy_arns      = sort(tolist(var.iam_managed_policy_arns))
    managed_role_keys            = sort(keys(var.iam_roles))
    managed_policy_attachment_ids = sort(keys(local.managed_policy_attachments))
  }
}
