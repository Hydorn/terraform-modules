# compute/ecs-cluster

A thin, Fargate-only ECS cluster, shared by every `compute/ecs-service` in one environment. Kept
deliberately minimal — cluster-level resources should change rarely, unlike task
definitions/services which get redeployed often.

## Usage

```hcl
module "cluster" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/compute/ecs-cluster?ref=v0.1.0"

  name_prefix = "wow-tracker-dev"
  tags = {
    Project     = "wow-collection-tracker"
    Environment = "dev"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name_prefix` | Cluster name | `string` | n/a |
| `tags` | Tags merged into the cluster | `map(string)` | `{}` |
| `enable_container_insights` | Enable Container Insights | `bool` | `false` |
| `enable_fargate_spot` | Make FARGATE_SPOT available as a capacity provider | `bool` | `true` |

## Outputs

| Name | Description |
|---|---|
| `cluster_id` | ECS cluster ID |
| `cluster_name` | ECS cluster name |
| `cluster_arn` | ECS cluster ARN |
