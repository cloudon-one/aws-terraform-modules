# AWS Service Control Policy (SCP) Terraform Module

This Terraform module creates and manages AWS Organizations Service Control Policies (SCPs) with flexible attachment to organizational units, accounts, and roots.

## Features

- **Multi-Policy Management**: Create multiple SCPs in a single module call
- **Flexible Attachments**: Attach policies to multiple targets (OUs, accounts, roots)
- **File-Based Policies**: Load policy content from JSON files for better organization
- **Comprehensive Outputs**: Get policy IDs, ARNs, and attachment details
- **Tagging Support**: Apply consistent tags to all policies

## Usage

### Basic Example

```hcl
module "security_policies" {
  source = "./aws-terraform-scp"

  policies = [
    {
      name        = "DenyRootAccess"
      description = "Prevents root user access to AWS services"
      content     = "./policies/deny-root-access.json"
      target_ids  = ["ou-root-example123", "123456789012"]
    },
    {
      name        = "RestrictRegions"
      description = "Restrict resource creation to approved regions"
      content     = "./policies/restrict-regions.json"
      target_ids  = ["ou-development-abc123"]
    }
  ]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "governance"
  }
}
```

### Complete Organizational Governance

```hcl
module "organizational_scps" {
  source = "./aws-terraform-scp"

  policies = [
    # Security baseline
    {
      name        = "SecurityBaseline"
      description = "Enforces basic security requirements across the organization"
      content     = "./policies/security-baseline.json"
      target_ids  = ["r-example123"]  # Root level
    },
    # Development environment restrictions
    {
      name        = "DevelopmentRestrictions"
      description = "Limits resource creation and access in development accounts"
      content     = "./policies/dev-restrictions.json"
      target_ids  = ["ou-development-abc123"]
    },
    # Production safeguards
    {
      name        = "ProductionSafeguards"
      description = "Enhanced security controls for production workloads"
      content     = "./policies/prod-safeguards.json"
      target_ids  = ["ou-production-def456"]
    }
  ]

  tags = {
    Environment     = "multi"
    ComplianceLevel = "high"
    ReviewDate      = "2024-12-31"
  }
}
```

## Policy File Examples

### Example: Deny Root Access Policy (`./policies/deny-root-access.json`)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyRootUserAccess",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalType": "Root"
        }
      }
    }
  ]
}
```

### Example: Region Restriction Policy (`./policies/restrict-regions.json`)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RestrictRegions",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": [
            "us-east-1",
            "us-west-2",
            "eu-west-1"
          ]
        }
      }
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| policies | List of SCP policies to deploy | `list(object)` | n/a | yes |
| tags | Tags to apply to all SCPs | `map(string)` | `{}` | no |

### Policy Object Structure

Each policy object in the `policies` list should have the following structure:

```hcl
{
  name        = string        # Unique name for the policy
  description = string        # Human-readable description
  content     = string        # Path to JSON policy file
  target_ids  = list(string)  # List of target IDs (OUs, accounts, or root)
}
```

## Outputs

| Name | Description |
|------|-------------|
| policy_ids | Map of policy names to their AWS policy IDs |
| policy_arns | Map of policy names to their AWS policy ARNs |
| attachments | List of all policy attachments with details |

### Output Usage Examples

```hcl
# Reference a specific policy ID
resource "aws_organizations_policy_attachment" "additional" {
  policy_id = module.security_policies.policy_ids["DenyRootAccess"]
  target_id = "123456789012"
}

# Get all policy ARNs for reference
output "all_policy_arns" {
  value = module.security_policies.policy_arns
}
```

## Target ID Types

SCPs can be attached to different AWS Organizations entities:

- **Root**: `r-example123` - Affects all accounts in the organization
- **Organizational Unit**: `ou-root-example123` - Affects all accounts in the OU
- **Account**: `123456789012` - Affects only the specific account

## Common SCP Use Cases

### 1. Security Baseline
```hcl
# Prevent deletion of CloudTrail, Config, and GuardDuty
# Enforce MFA for sensitive operations
# Block root user access
```

### 2. Compliance Controls  
```hcl
# Restrict regions for data residency
# Enforce encryption requirements
# Prevent public S3 buckets
```

### 3. Cost Management
```hcl
# Restrict expensive instance types
# Limit regions to reduce costs
# Prevent resource creation in non-approved services
```

### 4. Environment-Specific Controls
```hcl
# Development: Limit resource sizes and types
# Production: Enhanced security and change controls
# Sandbox: Time-based or usage-based restrictions
```

## Important Considerations

### ⚠️ **Critical Warnings**

1. **Careful Testing**: Always test SCPs in non-production environments first
2. **Administrative Access**: Ensure you maintain administrative access paths
3. **Emergency Procedures**: Have procedures to detach SCPs if they cause issues
4. **Policy Order**: SCPs are restrictive - they can only deny, not allow

### 🔧 **Best Practices**

1. **Start Small**: Begin with least restrictive policies and gradually tighten
2. **Use Staging**: Test policies in development OUs first
3. **Document Exceptions**: Clearly document any policy exceptions
4. **Regular Reviews**: Schedule periodic reviews of all SCPs
5. **Version Control**: Keep policy files in version control
6. **Naming Convention**: Use clear, descriptive names for policies

## Requirements

- Terraform >= 1.0
- AWS Provider >= 4.0
- AWS Organizations enabled
- Appropriate permissions to manage SCPs
- Valid organizational structure (Root, OUs, Accounts)

## Permissions Required

The executing principal needs the following IAM permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "organizations:CreatePolicy",
        "organizations:DeletePolicy",
        "organizations:UpdatePolicy",
        "organizations:AttachPolicy",
        "organizations:DetachPolicy",
        "organizations:ListPolicies",
        "organizations:DescribePolicy",
        "organizations:ListTagsForResource",
        "organizations:TagResource",
        "organizations:UntagResource"
      ],
      "Resource": "*"
    }
  ]
}
```

## Troubleshooting

### Common Issues

1. **Policy Attachment Fails**: Check that target IDs exist and are accessible
2. **JSON Validation Errors**: Validate policy JSON files before deployment
3. **Permission Denied**: Ensure the executing role has SCP management permissions
4. **Circular Dependencies**: Avoid SCPs that could lock out administrative access

## License

This module is open-source software licensed under the [MIT license](https://opensource.org/licenses/MIT).