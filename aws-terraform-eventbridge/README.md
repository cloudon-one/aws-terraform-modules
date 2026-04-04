# AWS EventBridge Rules Terraform Module

This Terraform module creates and manages AWS CloudWatch Event Rules (EventBridge rules).

## Features

- Create and manage EventBridge rules with custom event patterns

## Usage

```hcl
module "eventbridge_rules" {
  source = "git::https://git@github.com/cloudon-one/aws-terraform-modules.git//aws-terraform-eventbridge?ref=main"

  rules = [
    {
      name        = "capture-order-events"
      description = "Capture all order events"
      event_pattern = {
        source      = ["myapp.orders"]
        detail-type = ["Order Created"]
      }
    },
    {
      name        = "capture-user-events"
      description = "Capture user signup events"
      event_pattern = {
        source      = ["myapp.users"]
        detail-type = ["User Signed Up"]
      }
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| rules | List of EventBridge rules to create | `list(object({name, description, event_pattern}))` | `[]` | no |

### Rule Object Structure

| Field | Type | Description |
|-------|------|-------------|
| name | `string` | Name of the EventBridge rule |
| description | `string` | Description of the rule |
| event_pattern | `any` | Event pattern to match (will be JSON-encoded) |

## Outputs

| Name | Description |
|------|-------------|
| rule_arns | ARNs of the created EventBridge rules |

## Resources Created

- `aws_cloudwatch_event_rule` - One per rule in the `rules` list

## Limitations

- This module only creates event rules on the **default** event bus. Custom event buses are not supported.
- This module does **not** create event targets. Use `aws_cloudwatch_event_target` resources separately to route matched events.
- IAM roles/policies for targets must be managed separately.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## License

This module is released under the MIT License.
