# compute/alb

An internet-facing Application Load Balancer with an HTTPS listener (HTTP redirects to HTTPS).
Deliberately does **not** create target groups or listener rules — those belong to whichever
service attaches to it (see `compute/ecs-service`), so one ALB can be reused across multiple
services/host-based rules without modifying this module.

## Usage

```hcl
module "alb" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/compute/alb?ref=v0.1.0"

  name_prefix     = "wow-tracker-dev"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnet_ids
  certificate_arn = module.backend_cert.certificate_arn
  tags = {
    Project     = "wow-collection-tracker"
    Environment = "dev"
  }
}
```

Then point DNS at it:

```hcl
module "backend_dns" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/dns/alias-record?ref=v0.1.0"

  zone_id               = module.zone.zone_id
  record_name           = "api.collectiontracker.wow.emanuelrv.dev"
  alias_target_dns_name = module.alb.alias_target_dns_name
  alias_target_zone_id  = module.alb.alias_target_zone_id
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name_prefix` | ALB name (≤32 chars) | `string` | n/a |
| `tags` | Tags merged into every resource | `map(string)` | `{}` |
| `vpc_id` | VPC ID | `string` | n/a |
| `subnet_ids` | Subnet IDs for the ALB | `list(string)` | n/a |
| `certificate_arn` | ACM certificate ARN for HTTPS | `string` | n/a |
| `internal` | Internal (no public IP) vs internet-facing | `bool` | `false` |
| `ssl_policy` | ALB SSL negotiation policy | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` |
| `idle_timeout` | Idle timeout (seconds) | `number` | `60` |
| `enable_deletion_protection` | Enable deletion protection | `bool` | `false` |

## Outputs

| Name | Description |
|---|---|
| `https_listener_arn` | HTTPS listener ARN, for services to attach to |
| `http_listener_arn` | HTTP listener ARN |
| `security_group_id` | ALB security group ID |
| `alias_target_dns_name` | Normalized alias target DNS name |
| `alias_target_zone_id` | Normalized alias target zone ID |
