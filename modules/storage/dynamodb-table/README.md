# storage/dynamodb-table

A single DynamoDB table with a partition key, an optional sort key, and point-in-time recovery
enabled by default. On-demand (`PAY_PER_REQUEST`) billing by default, with `PROVISIONED` supported
via `read_capacity`/`write_capacity` when traffic is predictable enough to make it cheaper.

Intended for single-table designs: a partition key like `PK` and sort key like `SK`, with the
calling application encoding entity type and chunking into the key values themselves (e.g.
`PK = "CATALOG#mounts"`, `SK = "ITEM#000000123"` for a per-entry row, `SK = "META"` for a small
metadata row) rather than one item per top-level object. Item-per-entry chunking keeps individual
items well under DynamoDB's 400KB cap regardless of how large an overall collection grows, which a
single item holding a whole serialized array does not.

## Usage

```hcl
module "catalog_table" {
  source = "git::https://github.com/<you>/terraform-modules.git//modules/storage/dynamodb-table?ref=v0.2.0"

  name_prefix       = "wow-tracker-prod"
  table_name_suffix = "catalog"
  hash_key          = "PK"
  range_key         = "SK"

  tags = {
    Project = "wow-collection-tracker"
  }
}
```

The Lambda (or ECS task) role reading/writing this table needs its own least-privilege IAM policy
scoped to `module.catalog_table.table_arn` — this module does not create IAM policies, since access
patterns (which actions a given consumer needs) are consumer-specific.

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name_prefix` | Prefix for the table name | `string` | n/a |
| `table_name_suffix` | Suffix appended to `name_prefix` to form the table name | `string` | n/a |
| `tags` | Tags merged into the table | `map(string)` | `{}` |
| `hash_key` | Partition key attribute name | `string` | n/a |
| `hash_key_type` | Partition key attribute type (`S`, `N`, or `B`) | `string` | `"S"` |
| `range_key` | Sort key attribute name; omit for no sort key | `string` | `null` |
| `range_key_type` | Sort key attribute type (`S`, `N`, or `B`) | `string` | `"S"` |
| `billing_mode` | `"PAY_PER_REQUEST"` or `"PROVISIONED"` | `string` | `"PAY_PER_REQUEST"` |
| `read_capacity` | Provisioned read capacity units; required when `billing_mode = "PROVISIONED"` | `number` | `null` |
| `write_capacity` | Provisioned write capacity units; required when `billing_mode = "PROVISIONED"` | `number` | `null` |
| `point_in_time_recovery_enabled` | Whether to enable point-in-time recovery | `bool` | `true` |

## Outputs

| Name | Description |
|---|---|
| `table_name` | Table name |
| `table_arn` | Table ARN |
| `table_id` | Table ID |
