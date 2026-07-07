# ecr/repository

A single ECR repository with a lifecycle policy (expire untagged images; optionally cap the
number of retained tagged images) and scan-on-push. Reused by both `compute/ecs-service`
(container image for Fargate) and `compute/lambda-api` (when `package_type = "Image"`).

## Usage

```hcl
module "backend_ecr" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/ecr/repository?ref=v0.1.0"

  name_prefix = "wow-tracker-backend"
  tags = {
    Project = "wow-collection-tracker"
  }
}
```

CI builds and pushes images to `module.backend_ecr.repository_url:<tag>`; this module does not
build or push images itself.

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name_prefix` | Repository name (unique per account+region) | `string` | n/a |
| `tags` | Tags merged into the repository | `map(string)` | `{}` |
| `image_tag_mutability` | `MUTABLE` or `IMMUTABLE` | `string` | `"MUTABLE"` |
| `scan_on_push` | Scan images on push | `bool` | `true` |
| `untagged_image_expiry_days` | Expire untagged images after N days | `number` | `14` |
| `tagged_image_tag_prefixes` | Tag prefixes subject to retention cap; empty skips this rule | `list(string)` | `[]` |
| `tagged_image_keep_count` | Tagged images to retain (matching prefixes) | `number` | `10` |

## Outputs

| Name | Description |
|---|---|
| `repository_url` | Repository URL |
| `repository_arn` | Repository ARN |
| `repository_name` | Repository name |
