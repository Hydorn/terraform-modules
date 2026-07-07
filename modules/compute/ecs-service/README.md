# compute/ecs-service

A per-application Fargate task definition + service. Creates its own target group and listener
rule and attaches them to an existing ALB listener (from `compute/alb`) — the ALB module itself
stays generic and reusable across services.

## Health checks — read this before deploying

`health_check_path` **must** point at a lightweight endpoint that returns 200 immediately
without triggering any slow first-request logic (e.g. a cache rebuild on startup). If it points
at a real data endpoint that's slow on a cold app, the ALB will mark the task unhealthy
repeatedly and ECS will cycle it forever after every deploy. Tune `health_check_grace_period_seconds`
generously relative to real app startup time in addition to using a cheap health endpoint —
the grace period suppresses ALB-driven task replacement while the app is still coming up.

Note: `name_prefix`-`app_name` is also used as the ALB target group name, which AWS caps at 32
characters — keep the combination under that limit.

## Usage

```hcl
module "backend_service" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/compute/ecs-service?ref=v0.1.0"

  name_prefix = "wow-tracker-dev"
  app_name    = "backend"

  cluster_id             = module.cluster.cluster_id
  vpc_id                 = module.vpc.vpc_id
  subnet_ids              = module.vpc.public_subnet_ids
  alb_security_group_id  = module.alb.security_group_id
  https_listener_arn     = module.alb.https_listener_arn
  listener_rule_priority = 10
  host_headers           = ["api.collectiontracker.wow.emanuelrv.dev"]

  container_image = "${module.backend_ecr.repository_url}:latest"
  container_port  = 3000

  environment = {
    PORT        = "3000"
    CORS_ORIGIN = "https://collectiontracker.wow.emanuelrv.dev"
  }

  secrets = {
    BLIZZARD_CLIENT_ID     = aws_secretsmanager_secret.blizzard_client_id.arn
    BLIZZARD_CLIENT_SECRET = aws_secretsmanager_secret.blizzard_client_secret.arn
  }

  tags = {
    Project     = "wow-collection-tracker"
    Environment = "dev"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name_prefix` | Prefix for resource names | `string` | n/a |
| `app_name` | Application name | `string` | n/a |
| `tags` | Tags merged into every resource | `map(string)` | `{}` |
| `cluster_id` | ECS cluster ID | `string` | n/a |
| `vpc_id` | VPC ID | `string` | n/a |
| `subnet_ids` | Subnet IDs for tasks | `list(string)` | n/a |
| `assign_public_ip` | Assign a public IP to tasks | `bool` | `true` |
| `alb_security_group_id` | ALB's security group ID | `string` | n/a |
| `https_listener_arn` | ALB HTTPS listener ARN | `string` | n/a |
| `listener_rule_priority` | Listener rule priority (unique per ALB) | `number` | n/a |
| `host_headers` | Host-header values to route to this service | `list(string)` | `[]` |
| `container_image` | Full image reference | `string` | n/a |
| `container_port` | Container port | `number` | `3000` |
| `cpu` / `memory` | Fargate task sizing | `number` | `256` / `512` |
| `desired_count` | Number of tasks | `number` | `1` |
| `environment` | Plain env vars | `map(string)` | `{}` |
| `secrets` | Secret env vars (name -> Secrets Manager/SSM ARN) | `map(string)` | `{}` |
| `task_role_policy_arns` | Extra IAM policies for the task role | `list(string)` | `[]` |
| `log_retention_in_days` | CloudWatch log retention | `number` | `14` |
| `health_check_path` | ALB health check path | `string` | `"/api/health"` |
| `health_check_interval`/`timeout`/`healthy_threshold`/`unhealthy_threshold` | Health check tuning | `number` | `30`/`5`/`2`/`3` |
| `health_check_grace_period_seconds` | ECS deployment grace period | `number` | `60` |
| `deployment_minimum_healthy_percent` / `deployment_maximum_percent` | Deployment sizing | `number` | `100` / `200` |

## Outputs

| Name | Description |
|---|---|
| `service_name` | ECS service name |
| `target_group_arn` | Target group ARN |
| `security_group_id` | Service's security group ID |
| `task_role_arn` | Task IAM role ARN |
| `log_group_name` | CloudWatch log group name |
