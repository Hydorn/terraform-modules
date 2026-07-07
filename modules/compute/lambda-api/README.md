# compute/lambda-api

A single Lambda function — the cheaper alternative to the ECS Fargate path, meant to sit behind
`compute/apigw-http`. Supports zip or container-image packaging via `package_type`.

## Before using this for an existing Express/NestJS-style app

This module only creates the Lambda function/role/log group. It does **not** adapt an existing
HTTP server framework to Lambda's event format — that requires an app-code change (e.g. wrapping
a NestJS app with `@codegenie/serverless-express` and exporting a `handler`). Also be aware: API
Gateway's integration timeout is hard-capped at **30 seconds** regardless of this module's
`timeout` variable — if the app does slow first-request work (e.g. building a cache from an
upstream API on a cold start), that work must complete well under 30s or requests will fail
outright. See the repo README's "Backend compute: ECS Fargate vs Lambda" section.

## Usage (Zip packaging, default)

```hcl
module "backend_lambda" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/compute/lambda-api?ref=v0.1.0"

  name_prefix = "wow-tracker-dev"
  app_name    = "backend"

  filename = "${path.module}/../../backend/dist/lambda.zip"
  handler  = "lambda.handler"
  runtime  = "nodejs20.x"

  environment = {
    CORS_ORIGIN = "https://collectiontracker.wow.emanuelrv.dev"
  }

  secrets_manager_arns = [
    aws_secretsmanager_secret.blizzard_client_id.arn,
    aws_secretsmanager_secret.blizzard_client_secret.arn,
  ]

  tags = {
    Project     = "wow-collection-tracker"
    Environment = "dev"
  }
}
```

## Usage (container image packaging)

```hcl
module "backend_lambda" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/compute/lambda-api?ref=v0.1.0"

  name_prefix  = "wow-tracker-dev"
  app_name     = "backend"
  package_type = "Image"
  image_uri    = "${module.backend_ecr.repository_url}:latest"

  tags = {
    Project     = "wow-collection-tracker"
    Environment = "dev"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name_prefix` / `app_name` | Naming | `string` | n/a |
| `tags` | Tags merged into every resource | `map(string)` | `{}` |
| `package_type` | `"Zip"` or `"Image"` | `string` | `"Zip"` |
| `filename` / `s3_bucket` / `s3_key` / `s3_object_version` | Zip package source | `string` | `null` |
| `image_uri` | Image package source | `string` | `null` |
| `handler` / `runtime` | Zip-only function config | `string` | `"index.handler"` / `"nodejs20.x"` |
| `memory_size` | Memory (MB) | `number` | `512` |
| `timeout` | Function timeout (seconds) — see API Gateway cap note above | `number` | `30` |
| `environment` | Environment variables | `map(string)` | `{}` |
| `secrets_manager_arns` | Secrets Manager ARNs the role can read | `list(string)` | `[]` |
| `role_policy_arns` | Extra IAM policies for the role | `list(string)` | `[]` |
| `subnet_ids` / `security_group_ids` | Optional VPC config | `list(string)` | `[]` |
| `log_retention_in_days` | CloudWatch log retention | `number` | `14` |

## Outputs

| Name | Description |
|---|---|
| `function_name` | Function name |
| `function_arn` | Function ARN |
| `invoke_arn` | Invoke ARN, for the API Gateway integration |
| `role_arn` | Function role ARN |
