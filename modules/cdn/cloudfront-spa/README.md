# cdn/cloudfront-spa

CloudFront distribution in front of a private S3 bucket (`storage/s3-static-site`), using Origin
Access Control (OAC) — not the legacy Origin Access Identity, and not a public bucket. This
module **owns the S3 bucket policy** (it needs its own distribution ARN for the `AWS:SourceArn`
condition; creating the policy in the S3 module instead would be circular).

SPA-friendly behavior:
- `403`/`404` responses (no matching S3 key, e.g. a deep-linked client-side route) are rewritten
  to `200` + `/index.html` so React Router/etc. can handle routing.
- `/index.html` itself uses the `Managed-CachingDisabled` policy while every other asset uses
  `Managed-CachingOptimized` — otherwise a long-lived cached `index.html` could reference
  since-deleted hashed asset filenames from an old deploy.

## Region requirement

`certificate_arn` **must** be an ACM certificate in `us-east-1`, regardless of your primary
region — see `acm/certificate`'s README for the provider-aliasing pattern.

## Usage

```hcl
module "frontend_cdn" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/cdn/cloudfront-spa?ref=v0.1.0"

  name_prefix = "wow-tracker-dev-frontend"

  bucket_id                   = module.frontend_bucket.bucket_id
  bucket_arn                  = module.frontend_bucket.bucket_arn
  bucket_regional_domain_name = module.frontend_bucket.bucket_regional_domain_name

  aliases         = ["collectiontracker.wow.emanuelrv.dev"]
  certificate_arn = module.frontend_cert.certificate_arn

  tags = {
    Project     = "wow-collection-tracker"
    Environment = "dev"
  }
}

module "frontend_dns" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/dns/alias-record?ref=v0.1.0"

  zone_id               = module.zone.zone_id
  record_name           = "collectiontracker.wow.emanuelrv.dev"
  alias_target_dns_name = module.frontend_cdn.alias_target_dns_name
  alias_target_zone_id  = module.frontend_cdn.alias_target_zone_id
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name_prefix` | Naming prefix | `string` | n/a |
| `tags` | Tags merged into the distribution | `map(string)` | `{}` |
| `bucket_id` / `bucket_arn` / `bucket_regional_domain_name` | From storage/s3-static-site | `string` | n/a |
| `aliases` | CNAMEs for the distribution | `list(string)` | n/a |
| `certificate_arn` | ACM cert ARN, must be us-east-1 | `string` | n/a |
| `price_class` | CloudFront price class | `string` | `"PriceClass_100"` |
| `default_root_object` | Default root object | `string` | `"index.html"` |

## Outputs

| Name | Description |
|---|---|
| `distribution_id` | CloudFront distribution ID |
| `distribution_arn` | CloudFront distribution ARN |
| `alias_target_dns_name` | Normalized alias target DNS name |
| `alias_target_zone_id` | Normalized alias target zone ID (fixed CloudFront constant) |
