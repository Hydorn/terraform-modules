# storage/s3-static-site

A private S3 bucket for a static SPA build (e.g. Vite's `dist/` output). Fully private — all
public access blocked, no S3 website-hosting mode, no bucket ACLs (`BucketOwnerEnforced`) — meant
to be fronted exclusively by `cdn/cloudfront-spa` via Origin Access Control. This module does not
own the bucket policy (see `cdn/cloudfront-spa`'s README for why).

## Usage

```hcl
module "frontend_bucket" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/storage/s3-static-site?ref=v0.1.0"

  name_prefix = "wow-tracker-dev-frontend"
  tags = {
    Project     = "wow-collection-tracker"
    Environment = "dev"
  }
}
```

Uploading the actual build output (`frontend/dist/`) to this bucket is a CI/deploy-time concern,
not something this module does.

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name_prefix` | Bucket name (globally unique) | `string` | n/a |
| `tags` | Tags merged into the bucket | `map(string)` | `{}` |
| `versioning_enabled` | Enable bucket versioning | `bool` | `true` |
| `force_destroy` | Allow destroy even if non-empty | `bool` | `false` |

## Outputs

| Name | Description |
|---|---|
| `bucket_id` | Bucket name/id |
| `bucket_arn` | Bucket ARN |
| `bucket_regional_domain_name` | Regional domain name, for the CloudFront origin |
