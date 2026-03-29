# Production Terraform

This directory bootstraps a production-only Terraform layout for adopting the existing AWS estate in place.

The current repository already exposes one production dependency that must be preserved during import:

- API Gateway ID: `<rest-api-id>`
- Region: `us-east-2`
- Stage: `<stage-name>`
- Current base URL: `https://<rest-api-id>.execute-api.us-east-2.amazonaws.com/<stage-name>`

## Layout

- `versions.tf`: Terraform and provider version pinning with a partial S3 backend.
- `providers.tf`: AWS provider and shared default tags.
- `main.tf`: Root module wiring for `dns`, `hosting`, `api`, `data`, and `iam`.
- `terraform.tfvars.example`: Known production identifiers and placeholders for discovery output.
- `modules/*`: Domain-scoped inputs and outputs for discovery and eventual import blocks/resources.

The DNS module now includes importable Route53 resource blocks. The hosting module now includes importable Amplify app, branch, and domain association resources.

The current scaffold preserves the live Amplify repository, environment variables, rewrite rules, and branch metadata that were discovered during import so the first post-import plan stays close to zero drift.

## First Use

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and replace the placeholder IDs discovered from AWS.
  - `route53_zone_id` means the Route53 hosted zone ID.
  - Keep `terraform.tfvars` local. It is ignored by git in this directory so you can store discovered IDs without committing them.
2. Initialize Terraform with backend settings supplied at init time, for example:

```powershell
terraform init `
  -backend-config="bucket=<state-bucket-name>" `
  -backend-config="key=badminton-website/production/terraform.tfstate" `
  -backend-config="region=us-east-2"
```

3. Run `terraform plan` once the known production IDs are filled in.
4. Add import blocks and managed resources in dependency order: `dns`, `hosting`, `iam`, `data`, `api`.

## First Imports

Once the backend is initialized, import in this order:

```powershell
terraform import 'module.dns.aws_route53_zone.this[0]' <route53_hosted_zone_id>
terraform import 'module.hosting.aws_amplify_app.this[0]' <amplify_app_id>
terraform import 'module.hosting.aws_amplify_branch.this[0]' <amplify_app_id>/<branch_name>
terraform import 'module.hosting.aws_amplify_domain_association.this[0]' <amplify_app_id>/<domain_name>
```

Keep `route53_records = {}` until you decide which record sets Terraform should own explicitly.

The imported Route53 hosted zone currently ignores Terraform-added comments and tags to avoid unnecessary brownfield churn during the first pass.

## Backend Next

The IAM and DynamoDB modules now support real resource imports driven by `iam_roles` and `dynamodb_tables` in the local tfvars file.

Once the DNS and hosting plan is acceptable, the next imports are:

```powershell
terraform import 'module.iam.aws_iam_role.this["DynamoDBFullAccess"]' DynamoDBFullAccess
terraform import 'module.iam.aws_iam_role.this["ResetGuestLimit-role-dda1aroe"]' ResetGuestLimit-role-dda1aroe
terraform import 'module.iam.aws_iam_role_policy_attachment.this["DynamoDBFullAccess arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"]' 'DynamoDBFullAccess/arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess'
terraform import 'module.iam.aws_iam_role_policy_attachment.this["<role-name> <policy-arn>"]' '<role-name>/<policy-arn>'
terraform import 'module.data.aws_dynamodb_table.this["badmintonWebsite"]' badmintonWebsite
```

## Lambda Preservation

The API module now supports real Lambda function imports driven by `lambda_functions` in the local tfvars file.

Before importing the Lambda functions, download the current deployment packages into the local `artifacts/` directory using fresh signed URLs from `aws lambda get-function`. The current scaffold ignores code drift on the first pass so the brownfield import can proceed before the zip artifacts are fully normalized.

Planned Lambda import commands:

```powershell
terraform import 'module.api.aws_lambda_function.this["getGuestLimit"]' getGuestLimit
terraform import 'module.api.aws_lambda_function.this["UpdateGuestLimit"]' UpdateGuestLimit
terraform import 'module.api.aws_lambda_function.this["ResetGuestLimit"]' ResetGuestLimit
```

## API Gateway Next

The API module now also supports the imported REST API, its root methods, integrations, method responses, integration responses, and the existing `Dev` stage.

Planned API Gateway import commands after the Lambda plan is acceptable:

```powershell
terraform import 'module.api.aws_api_gateway_rest_api.this[0]' <rest-api-id>
terraform import 'module.api.aws_api_gateway_method.root["GET"]' <rest-api-id>/<root-resource-id>/GET
terraform import 'module.api.aws_api_gateway_method.root["POST"]' <rest-api-id>/<root-resource-id>/POST
terraform import 'module.api.aws_api_gateway_method.root["OPTIONS"]' <rest-api-id>/<root-resource-id>/OPTIONS
terraform import 'module.api.aws_api_gateway_integration.root["GET"]' <rest-api-id>/<root-resource-id>/GET
terraform import 'module.api.aws_api_gateway_integration.root["POST"]' <rest-api-id>/<root-resource-id>/POST
terraform import 'module.api.aws_api_gateway_integration.root["OPTIONS"]' <rest-api-id>/<root-resource-id>/OPTIONS
terraform import 'module.api.aws_api_gateway_method_response.root["GET_200"]' <rest-api-id>/<root-resource-id>/GET/200
terraform import 'module.api.aws_api_gateway_method_response.root["POST_200"]' <rest-api-id>/<root-resource-id>/POST/200
terraform import 'module.api.aws_api_gateway_method_response.root["OPTIONS_200"]' <rest-api-id>/<root-resource-id>/OPTIONS/200
terraform import 'module.api.aws_api_gateway_integration_response.root["GET_200"]' <rest-api-id>/<root-resource-id>/GET/200
terraform import 'module.api.aws_api_gateway_integration_response.root["POST_200"]' <rest-api-id>/<root-resource-id>/POST/200
terraform import 'module.api.aws_api_gateway_integration_response.root["OPTIONS_200"]' <rest-api-id>/<root-resource-id>/OPTIONS/200
terraform import 'module.api.aws_api_gateway_stage.this[0]' <rest-api-id>/<stage-name>
```

## Current Scope

This scaffold is intentionally conservative. It does not attempt to recreate or reinterpret live AWS resources yet. It establishes:

- a production state root
- shared tagging conventions
- module boundaries that match the import plan
- a single place to store the production IDs that discovery will produce

## Notes

- Commit `terraform.tfvars.example`, not `terraform.tfvars`. The example file is for safe placeholders and documentation only.
- Do not commit `.terraform/`, state files, Lambda zip artifacts, or any shell history containing credentials.
- Keep Amplify-managed CloudFront internals out of the first pass unless there is a first-class Terraform resource you explicitly intend to own.
- Treat Lambda code recovery and API Gateway export as prerequisites before modeling mutable backend resources.
