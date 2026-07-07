# dns/hosted-zone

Creates a new Route53 public hosted zone, or looks up an existing one by name — same output
shape either way so downstream modules (`acm/certificate`, `dns/alias-record`) never need to
know which path was taken.

## Usage

```hcl
module "zone" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/dns/hosted-zone?ref=v0.1.0"

  domain_name = "wow.emanuelrv.dev"
  tags = {
    Project = "wow-collection-tracker"
  }
}
```

When `create_zone = true` (default), copy `name_servers` to the parent zone/registrar's NS
records — a one-time manual step Terraform can't perform for you.

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `domain_name` | Domain name for the hosted zone | `string` | n/a |
| `create_zone` | Create a new zone (true) or look up an existing one (false) | `bool` | `true` |
| `comment` | Comment set on the zone when created | `string` | `"Managed by Terraform"` |
| `tags` | Tags merged into the zone (create path only) | `map(string)` | `{}` |

## Outputs

| Name | Description |
|---|---|
| `zone_id` | Hosted zone ID |
| `name_servers` | Name servers (only set when `create_zone = true`) |
