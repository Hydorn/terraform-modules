# terraform-modules

Reusable Terraform modules for hosting web apps on AWS. This repo contains **modules only** — no root configuration is deployed from here. Each consuming project owns its own `infra/` folder (in that project's repo) that wires these modules together, holds its own Terraform state backend configuration, and its own CI/CD. State-backend bootstrapping (S3 bucket + DynamoDB lock table) is intentionally out of scope here and is each consumer's own responsibility.

First consumer: [wow-collection-tracker](../wow-collection-tracker). Designed generically so future projects can reuse the same modules.

## Usage

Modules are consumed via Terraform's git source syntax, pinned to a tag:

```hcl
module "vpc" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/networking/vpc?ref=v0.1.0"

  name_prefix = "wow-tracker-dev"
  tags = {
    Project     = "wow-collection-tracker"
    Environment = "dev"
  }
}
```

Releases are tagged repo-wide (`v0.1.0`, `v0.2.0`, ...) rather than per-module.

## Conventions

Every module accepts:

- `name_prefix` (string) — used for resource `Name` tags and anywhere AWS requires a globally-unique / DNS-safe name (S3 buckets, ECR repos). Compose this yourself, e.g. `"${project}-${environment}"`.
- `tags` (map(string), default `{}`) — merged into every resource's tags. Modules deliberately do **not** hardcode `Project`/`Environment` as first-class variables, so you can use whatever tagging taxonomy your org prefers.

Every module directory contains `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`. Provider requirement: Terraform `>= 1.5.0`, AWS provider `~> 5.0`.

Region note: all modules are region-agnostic, but if you use `cdn/cloudfront-spa`, its `certificate_arn` **must** come from an ACM certificate in `us-east-1` regardless of your primary region (a CloudFront/ACM requirement) — pass an aliased `aws` provider to `acm/certificate` for that call if your primary region differs. `compute/alb` and `compute/apigw-http` certs, by contrast, must be in the *same* region as the ALB/API Gateway itself.

## Modules

| Module | Responsibility |
|---|---|
| `networking/vpc` | VPC, public/private subnets across 2 AZs, IGW, optional NAT gateway |
| `dns/hosted-zone` | Create or look up a Route53 public hosted zone |
| `dns/alias-record` | Generic Route53 alias record, reused for CloudFront / ALB / API Gateway targets |
| `acm/certificate` | DNS-validated ACM certificate (creates validation records + waits for issuance) |
| `ecr/repository` | ECR repository with lifecycle policy, shared by ECS and Lambda-container-image paths |
| `compute/ecs-cluster` | Thin, shared Fargate ECS cluster |
| `compute/alb` | Internet-facing ALB + HTTPS listener (no target groups — those belong to services) |
| `compute/ecs-service` | Per-app Fargate task definition + service, attaches its own target group to an ALB listener |
| `compute/lambda-api` | Lambda function (zip or container image) for the "cheap" backend path |
| `compute/apigw-http` | API Gateway HTTP API (v2) fronting a Lambda, with custom domain mapping |
| `storage/s3-static-site` | Private S3 bucket for a static SPA build, fronted by CloudFront (no S3 website hosting) |
| `cdn/cloudfront-spa` | CloudFront distribution with Origin Access Control to the S3 bucket, SPA-friendly routing |

## Backend compute: ECS Fargate vs Lambda

Two swappable backend paths are provided:

- **`compute/ecs-cluster` + `compute/alb` + `compute/ecs-service`** — a VPC-hosted Fargate service behind an ALB. More moving parts, but no cold-start/timeout constraints.
- **`compute/lambda-api` + `compute/apigw-http`** — a single Lambda behind an HTTP API. Cheaper at low traffic, but has a hard constraint worth knowing before you pick it: **API Gateway's integration timeout is capped at 30 seconds** regardless of the Lambda's own configured timeout. If your app does expensive first-request work (e.g. building a cache from an upstream API on cold start), anything over ~30s will fail outright, not just be slow. For wow-collection-tracker specifically, the backend's cache rebuild can take 30-70s on a cold cache — see that repo's suggestions for mitigations (pre-built cache data shipped in the deployment package, or an external cache store) before adopting the Lambda path for it. Until addressed, prefer the ECS path for that app; the Lambda module is fully built and ready once the cache strategy is revisited.

Both paths' "edge" resources (ALB / API Gateway custom domain) and the CloudFront distribution normalize their AWS-native alias attributes into a common `alias_target_dns_name` / `alias_target_zone_id` pair, so `dns/alias-record` works identically regardless of which path a given environment uses.
