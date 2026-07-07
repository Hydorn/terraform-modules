# networking/vpc

VPC with public subnets (2 AZs by default) and an internet gateway. Private subnets + a single
NAT gateway are created only when `enable_nat_gateway = true`.

## Why NAT is off by default

For stateless workloads with no inbound access path other than through a load balancer's
security group, running in a public subnet with a public IP (and a security group that allows
no inbound traffic except from the ALB) is safe and avoids NAT gateway cost (~$0.045/hr plus
per-GB data processing — often more than the compute cost itself for a low-traffic service).
Flip `enable_nat_gateway` to `true` when a workload must not have a public IP at all; this
module will then create private subnets, a single shared NAT gateway, and the private route
table pointing at it.

## Usage

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

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name_prefix` | Prefix used for resource names/tags | `string` | n/a |
| `tags` | Tags merged into every resource | `map(string)` | `{}` |
| `vpc_cidr` | CIDR block for the VPC | `string` | `"10.0.0.0/16"` |
| `az_count` | Number of AZs to spread subnets across | `number` | `2` |
| `enable_nat_gateway` | Create private subnets + a NAT gateway | `bool` | `false` |

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | ID of the created VPC |
| `vpc_cidr_block` | CIDR block of the created VPC |
| `public_subnet_ids` | IDs of the public subnets |
| `private_subnet_ids` | IDs of the private subnets (empty unless NAT enabled) |
| `availability_zones` | AZs used, same order as the subnet id lists |
