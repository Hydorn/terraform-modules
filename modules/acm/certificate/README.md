# acm/certificate

Requests a DNS-validated ACM certificate, creates the validation records in the given hosted
zone, and blocks on `aws_acm_certificate_validation` until AWS confirms issuance. Always consume
`certificate_arn` from this module's output (the validated ARN) rather than reaching into the
raw `aws_acm_certificate` resource, so downstream resources can't race ahead of validation.

## Region note

If this certificate feeds `cdn/cloudfront-spa`, it **must** be requested in `us-east-1`
regardless of your primary region — pass an aliased provider:

```hcl
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "frontend_cert" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/acm/certificate?ref=v0.1.0"
  providers = {
    aws = aws.us_east_1
  }

  domain_name = "collectiontracker.wow.emanuelrv.dev"
  zone_id     = module.zone.zone_id
}
```

Certificates feeding `compute/alb` or `compute/apigw-http` must be in the *same* region as those
resources instead — if that's also `us-east-1` (as in the default setup), no provider aliasing
is needed at all.

## Usage

```hcl
module "backend_cert" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/acm/certificate?ref=v0.1.0"

  domain_name = "api.collectiontracker.wow.emanuelrv.dev"
  zone_id     = module.zone.zone_id
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `domain_name` | Primary domain name for the certificate | `string` | n/a |
| `subject_alternative_names` | Additional domain names to cover | `list(string)` | `[]` |
| `zone_id` | Hosted zone ID for DNS validation records | `string` | n/a |
| `tags` | Tags merged into the certificate | `map(string)` | `{}` |

## Outputs

| Name | Description |
|---|---|
| `certificate_arn` | ARN of the validated certificate |
