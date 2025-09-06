# AWS IAM Terraform Module

This comprehensive Terraform module provides a complete IAM (Identity and Access Management) solution for AWS, including sub-modules for different IAM components.

## Features

- **Modular Design**: Separate sub-modules for different IAM components
- **Complete IAM Management**: Users, roles, groups, policies, and service accounts
- **Cross-Account Support**: Assumable roles for cross-account access
- **Account-Level Settings**: Account-wide IAM configurations
- **Security Best Practices**: Built-in security configurations

## Sub-modules

### 1. Users (`users/`)
Manages IAM users with login profiles and access keys.

**Key Features:**
- User creation with optional login profiles
- Access key generation with PGP encryption support
- SSH key management
- Password policies and reset requirements
- Policy attachments

**Usage:**
```hcl
module "iam_user" {
  source = "./aws-terraform-iam/users"
  
  name                          = "developer"
  create_iam_user_login_profile = true
  create_iam_access_key         = true
  password_reset_required       = true
  policy_arns                   = ["arn:aws:iam::aws:policy/PowerUserAccess"]
  
  tags = {
    Environment = "dev"
    Team        = "developers"
  }
}
```

### 2. Roles (`roles/`)
Creates IAM roles for AWS services and cross-account access.

**Usage:**
```hcl
module "iam_role" {
  source = "./aws-terraform-iam/roles"
  
  # Role configuration variables
}
```

### 3. Groups (`groups/`)
Manages IAM groups for organizing users.

**Usage:**
```hcl
module "iam_groups" {
  source = "./aws-terraform-iam/groups"
  
  # Group configuration variables
}
```

### 4. Policies (`policies/`)
Handles IAM policy attachments to users, roles, and groups.

**Key Features:**
- Attach existing AWS managed policies
- Support for custom policy ARNs
- Automatic member type detection (users/roles/groups)
- Lifecycle management to prevent conflicts

**Usage:**
```hcl
module "iam_policies" {
  source = "./aws-terraform-iam/policies"
  
  policies = [
    {
      name    = "s3-read-only"
      arn     = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
      members = ["user:developer", "role:ec2-role"]
    }
  ]
}
```

### 5. Service Accounts (`service-accounts/`)
Creates service accounts for applications and services.

**Usage:**
```hcl
module "service_accounts" {
  source = "./aws-terraform-iam/service-accounts"
  
  # Service account configuration
}
```

### 6. Assumable Role (`assumable-role/`)
Creates roles that can be assumed by other AWS accounts or services.

**Usage:**
```hcl
module "assumable_role" {
  source = "./aws-terraform-iam/assumable-role"
  
  # Assumable role configuration
}
```

### 7. Account (`account/`)
Configures account-level IAM settings.

**Usage:**
```hcl
module "iam_account" {
  source = "./aws-terraform-iam/account"
  
  # Account-level IAM settings
}
```

## Security Considerations

⚠️ **Security Recommendations:**

1. **MFA Enforcement**: Enable MFA for all users with console access
2. **Access Key Rotation**: Regularly rotate access keys
3. **Least Privilege**: Apply minimal required permissions
4. **PGP Encryption**: Use PGP keys to encrypt sensitive outputs
5. **Password Policies**: Enforce strong password requirements

## Common Usage Patterns

### Complete IAM Setup
```hcl
# Account-level settings
module "iam_account" {
  source = "./aws-terraform-iam/account"
}

# Create developers group
module "developers_group" {
  source = "./aws-terraform-iam/groups"
  # Group configuration
}

# Create developer users
module "developer_users" {
  source = "./aws-terraform-iam/users"
  
  name                          = "john.doe"
  create_iam_user_login_profile = true
  create_iam_access_key         = false  # Security: Avoid access keys when possible
  password_reset_required       = true
  
  policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
}

# Attach policies
module "policy_attachments" {
  source = "./aws-terraform-iam/policies"
  
  policies = [
    {
      name    = "developer-access"
      arn     = "arn:aws:iam::aws:policy/PowerUserAccess"
      members = ["group:developers", "user:john.doe"]
    }
  ]
}
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 4.0
- Valid AWS credentials with IAM permissions

## Important Notes

1. **State Management**: IAM resources contain sensitive information. Secure your Terraform state.
2. **Permissions**: The executing principal needs extensive IAM permissions.
3. **Dependencies**: Some sub-modules may depend on resources created by others.
4. **Lifecycle Management**: The policies module uses lifecycle rules to prevent conflicts.

## Outputs

Each sub-module provides relevant outputs:
- **Users**: User ARNs, access keys, login profiles
- **Roles**: Role ARNs, assume role policy documents  
- **Groups**: Group ARNs and names
- **Policies**: Attachment details

## Security Best Practices

1. **Enable MFA**: Force MFA for all console users
2. **Rotate Credentials**: Implement automated key rotation
3. **Monitor Access**: Use CloudTrail to monitor IAM activities
4. **Use Temporary Credentials**: Prefer assumable roles over access keys
5. **Regular Audits**: Periodically review permissions and remove unused resources

## License

This module is open-source software licensed under the [MIT license](https://opensource.org/licenses/MIT).