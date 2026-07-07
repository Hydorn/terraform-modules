# dns/alias-record

Generic Route53 alias record. One module, reused for every edge target — CloudFront
distribution, ALB, or API Gateway custom domain — because each of those modules normalizes its
native alias attributes into the same `alias_target_dns_name` / `alias_target_zone_id` pair.

## Usage

```hcl
module "frontend_dns" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/dns/alias-record?ref=v0.1.0"

  zone_id                = module.zone.zone_id
  record_name            = "collectiontracker.wow.emanuelrv.dev"
  alias_target_dns_name  = module.cloudfront.alias_target_dns_name
  alias_target_zone_id   = module.cloudfront.alias_target_zone_id
}

module "backend_dns" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/dns/alias-record?ref=v0.1.0"

  zone_id                = module.zone.zone_id
  record_name            = "api.collectiontracker.wow.emanuelrv.dev"
  alias_target_dns_name  = module.alb.alias_target_dns_name   # or module.apigw_http.alias_target_dns_name
  alias_target_zone_id   = module.alb.alias_target_zone_id    # or module.apigw_http.alias_target_zone_id
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `zone_id` | Hosted zone ID | `string` | n/a |
| `record_name` | Fully-qualified record name | `string` | n/a |
| `type` | Record type | `string` | `"A"` |
| `alias_target_dns_name` | DNS name of the alias target | `string` | n/a |
| `alias_target_zone_id` | Hosted zone ID of the alias target | `string` | n/a |
| `evaluate_target_health` | Evaluate alias target health | `bool` | `false` |

## Outputs

| Name | Description |
|---|---|
| `fqdn` | Fully-qualified domain name of the created record |
