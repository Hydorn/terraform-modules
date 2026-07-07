# compute/apigw-http

An API Gateway HTTP API (v2) — cheaper than REST API (v1), no extra charge for custom domains —
fronting a single Lambda via a catch-all `$default` route and proxy integration. The custom
domain is mapped at the domain root with an empty base path, since the backend app already owns
its own internal path prefix (e.g. NestJS's global `/api` prefix); adding an API-Gateway-level
base path on top would double it up into `/api/api/...`.

## Usage

```hcl
module "backend_api" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/compute/apigw-http?ref=v0.1.0"

  name_prefix = "wow-tracker-dev"
  app_name    = "backend"

  lambda_invoke_arn     = module.backend_lambda.invoke_arn
  lambda_function_name  = module.backend_lambda.function_name

  domain_name     = "api.collectiontracker.wow.emanuelrv.dev"
  certificate_arn = module.backend_cert.certificate_arn

  tags = {
    Project     = "wow-collection-tracker"
    Environment = "dev"
  }
}

module "backend_dns" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/dns/alias-record?ref=v0.1.0"

  zone_id               = module.zone.zone_id
  record_name           = "api.collectiontracker.wow.emanuelrv.dev"
  alias_target_dns_name = module.backend_api.alias_target_dns_name
  alias_target_zone_id  = module.backend_api.alias_target_zone_id
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name_prefix` / `app_name` | Naming | `string` | n/a |
| `tags` | Tags merged into every resource | `map(string)` | `{}` |
| `lambda_invoke_arn` | Target Lambda's invoke ARN | `string` | n/a |
| `lambda_function_name` | Target Lambda's function name | `string` | n/a |
| `domain_name` | Custom domain for the API | `string` | n/a |
| `certificate_arn` | ACM cert ARN, same region as this API Gateway | `string` | n/a |

## Outputs

| Name | Description |
|---|---|
| `api_id` | API Gateway API ID |
| `invoke_url` | Default execute-api invoke URL |
| `alias_target_dns_name` | Normalized alias target DNS name |
| `alias_target_zone_id` | Normalized alias target zone ID |
