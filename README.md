# AWS Terraform Modules Collection

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0-blue)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-~%3E5.0-orange)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

This repository contains a comprehensive collection of **production-ready** and **security-hardened** Terraform modules for AWS infrastructure provisioning. Each module is designed to be modular, maintainable, and follows AWS security best practices with **security-by-default** configurations.

## Available Modules

### Networking
- **aws-terraform-core-vpc**: Core VPC infrastructure setup
- **aws-terraform-vpc**: Standard VPC configuration
- **aws-terraform-peering**: VPC peering connections
- **aws-terraform-tgw**: Transit Gateway configuration
- **aws-terraform-vpn**: VPN connection setup

### Computing
- **aws-terraform-ec2**: EC2 instance provisioning (🔒 **Security**: Encryption enabled by default)
- **aws-terraform-eks**: Elastic Kubernetes Service cluster setup (🔒 **Security**: Private API endpoint by default)

### Storage & Databases
- **aws-terraform-s3**: S3 bucket configuration
- **aws-terraform-dynamodb**: DynamoDB tables
- **aws-terraform-rds**: Relational Database Service
- **aws-terraform-rds-aurora**: Amazon Aurora cluster setup
- **aws-terraform-redis**: ElastiCache Redis configuration

### Security & Identity
- **aws-terraform-accounts**: AWS account management
- **aws-terraform-acm**: AWS Certificate Manager
- **aws-terraform-cloudtrail**: CloudTrail logging
- **aws-terraform-iam**: IAM resource management (🆕 Comprehensive documentation)
  - account: Account-level IAM settings
  - assumable-role: Cross-account role assumption
  - groups: IAM group management
  - policies: Custom IAM policies
  - roles: IAM roles
  - service-accounts: Service account configuration
  - users: IAM user management (🔒 **Security**: Access keys disabled by default)
- **aws-terraform-scp**: Service Control Policies for AWS Organizations (🆕 Full documentation)

### Application Services
- **aws-terraform-apigw**: API Gateway setup
- **aws-terraform-eventbridge**: EventBridge/CloudWatch Events
- **aws-terraform-sns**: Simple Notification Service

## ✨ Recent Improvements

### 🔐 Security Enhancements
- **Security-by-default**: All modules now use secure defaults
- **Encryption**: EC2 instances have encryption enabled by default
- **Access Control**: EKS clusters use private endpoints by default
- **IAM Security**: Access key creation disabled by default to prevent credential exposure

### 📚 Documentation
- **Complete Coverage**: All 20 modules now have comprehensive documentation
- **Usage Examples**: Detailed examples with security best practices
- **Security Guidance**: Clear security considerations and recommendations

### 🔧 Standardization
- **Version Constraints**: All modules have consistent Terraform and provider versions
- **Code Quality**: 100% formatted and validated code
- **Consistent Structure**: Standardized module organization

## Module Structure
Each module follows a consistent structure:
```
module-name/
├── README.md        # 📚 Comprehensive module documentation
├── main.tf          # 🏗️ Main module logic
├── variables.tf     # ⚙️ Input variables with secure defaults
├── outputs.tf       # 📤 Output values for integration
└── versions.tf      # 🔧 Provider version constraints (✅ All modules)
```

## 🚀 Quick Start

### Basic Usage

Each module can be used by referencing it in your Terraform configuration:

```hcl
module "example" {
  source = "git::https://git@github.com/cloudon-one/aws-terraform-modules.git//aws-terraform-<service>?ref=main"
  
  # Module specific variables
  # ...
}
```

### Security-First Examples

#### Secure EC2 Instance with Encryption
```hcl
module "secure_ec2" {
  source = "./aws-terraform-ec2"
  
  instances = [
    {
      name                        = "web-server"
      ami                         = "ami-0abcdef1234567890"
      instance_type               = "t3.medium"
      availability_zone           = "us-west-2a"
      subnet_id                   = "subnet-12345678"
      private_ip                  = "10.0.1.10"
      associate_public_ip_address = "false"
      ebs_block_device           = []
      tags = {
        Environment = "production"
        Encrypted   = "true"
      }
    }
  ]
  
  # 🔒 Security: Encryption enabled by default
  enable_root_block_device_encryption = true
  enable_ebs_encryption              = true
  kms_key_id                        = "alias/my-key"  # Optional: Use customer-managed key
}
```

#### Secure EKS Cluster with Private API
```hcl
module "secure_eks" {
  source = "./aws-terraform-eks"
  
  cluster_name    = "production-cluster"
  eks_version     = "1.34"
  iam_role_arn    = "arn:aws:iam::123456789012:role/eks-cluster-role"
  subnet_ids      = ["subnet-12345678", "subnet-87654321"]
  
  # 🔒 Security: Private API endpoint by default
  cluster_endpoint_public_access  = false  # Default: false
  cluster_endpoint_private_access = true   # Default: true
  
  # Only allow specific CIDRs if public access is needed
  cluster_endpoint_public_access_cidrs = ["10.0.0.0/16"]
  
  eks_managed_node_groups = [
    {
      name           = "workers"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      ami_type       = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"
      access_entries = []
      tags = {
        Environment = "production"
      }
    }
  ]
}
```

#### Secure IAM User (No Access Keys)
```hcl
module "secure_iam_user" {
  source = "./aws-terraform-iam/users"
  
  name                          = "developer"
  create_iam_user_login_profile = true
  create_iam_access_key         = false  # 🔒 Default: false (secure)
  password_reset_required       = true
  
  policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
  
  tags = {
    Team        = "development"
    Environment = "dev"
  }
}
```

## 📋 Requirements

- **Terraform** >= 1.0 (✅ Enforced in all modules)
- **AWS Provider** ~> 5.0 (✅ Standardized across all modules)
- Valid AWS credentials configured
- Appropriate IAM permissions for the resources being created

## 🛡️ Security Best Practices

This repository implements **security-by-default** principles:

### ✅ What's Secure by Default
- **EC2 Encryption**: Root and EBS volumes are encrypted automatically
- **EKS Private Access**: API endpoints private by default
- **IAM Security**: No access keys created by default
- **Version Pinning**: All provider versions constrained
- **Input Validation**: Comprehensive variable validation

### 🔧 Security Configuration Options
Each module provides security configuration options:

```hcl
# Enable/disable security features as needed
enable_encryption = true           # Default: true
public_access    = false          # Default: false  
access_keys      = false          # Default: false
```

### 🚨 Security Recommendations
1. **Review Defaults**: Understand the secure defaults before overriding
2. **Use Private Resources**: Prefer private subnets and endpoints
3. **Enable Encryption**: Use customer-managed KMS keys when possible
4. **Limit Access**: Use least privilege principles
5. **Monitor Changes**: Enable CloudTrail for all AWS accounts

## 📊 Module Status

| Module | Documentation | Version Constraints | Outputs | Security |
|--------|---------------|-------------------|---------|----------|
| aws-terraform-accounts | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-acm | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-apigw | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-cloudtrail | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-core-vpc | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-dynamodb | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-ec2 | ✅ | ✅ | ✅ | 🔒 **Enhanced** |
| aws-terraform-eks | ✅ | ✅ | ✅ | 🔒 **Enhanced** |
| aws-terraform-eventbridge | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-iam | 🆕 **New** | ✅ | 🆕 **New** | 🔒 **Enhanced** |
| aws-terraform-peering | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-rds | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-rds-aurora | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-redis | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-s3 | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-scp | 🆕 **New** | ✅ | ✅ | ✅ |
| aws-terraform-sns | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-tgw | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-vpc | ✅ | ✅ | ✅ | ✅ |
| aws-terraform-vpn | ✅ | ✅ | ✅ | ✅ |

**Legend:**
- ✅ Complete
- 🆕 Recently Added/Updated  
- 🔒 Security Enhanced

## 🤝 Contributing

We welcome contributions! Please follow our security-first approach:

### 🔐 Security-First Development
1. **Security Review**: All changes undergo security review
2. **Secure Defaults**: New features should be secure by default
3. **Documentation**: Security implications must be documented
4. **Testing**: Include security-focused tests

### 📝 Contribution Process
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following our patterns:
   - Add comprehensive documentation
   - Include security considerations
   - Add version constraints
   - Provide usage examples
4. Run validation: `terraform fmt -recursive . && terraform validate`
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### 🧪 Testing Your Changes
```bash
# Format code
terraform fmt -recursive .

# Validate all modules
find . -name "*.tf" -path "./aws-terraform-*" -exec dirname {} \; | sort -u | xargs -I {} terraform -chdir={} validate

# Check documentation
./scripts/check-docs.sh  # If available
```

## 🆘 Support & Community

### 📖 Getting Help
1. **Module Documentation**: Check the specific module's README first
2. **Security Questions**: Review the Security Best Practices section
3. **Issues**: Open an issue with detailed information
4. **Discussions**: Use GitHub Discussions for questions

### 🐛 Reporting Issues
When reporting issues, please include:
- Module name and version
- Terraform version
- AWS Provider version  
- Security context (if applicable)
- Minimal reproduction case

### 💡 Feature Requests
For new features or enhancements:
- Explain the use case
- Consider security implications
- Provide implementation ideas
- Follow existing patterns

## 📈 Roadmap

### 🔮 Upcoming Enhancements
- [ ] **Enhanced Security**: Additional security hardening options
- [ ] **Compliance**: SOC 2, PCI DSS, and GDPR compliance helpers
- [ ] **Monitoring**: Integrated observability and alerting
- [ ] **Automation**: Pre-commit hooks and automated testing
- [ ] **Examples**: Real-world usage examples and patterns

### 🎯 Goals
- **100% Security Coverage**: All modules follow security best practices
- **Complete Documentation**: Comprehensive docs for all modules
- **Community Driven**: Active community contributions and feedback
- **Production Ready**: Enterprise-grade reliability and support

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏆 Acknowledgments

- Built with security-first principles
- Inspired by AWS Well-Architected Framework
- Community-driven development
- Continuous security improvements

---

## 📚 Module Documentation Index

| Module | Description | Key Features |
|--------|-------------|--------------|
| [aws-terraform-iam](aws-terraform-iam/README.md) | Complete IAM management | 🆕 Comprehensive docs, 🔒 Secure defaults |
| [aws-terraform-scp](aws-terraform-scp/README.md) | Service Control Policies | 🆕 Full documentation, Policy examples |
| [aws-terraform-ec2](aws-terraform-ec2/) | EC2 instances | 🔒 Encryption by default |
| [aws-terraform-eks](aws-terraform-eks/) | EKS clusters | 🔒 Private endpoints by default |
| [aws-terraform-s3](aws-terraform-s3/README.md) | S3 buckets | Public access blocked |
| [aws-terraform-vpc](aws-terraform-vpc/README.md) | VPC networking | Flexible subnet configuration |
| And 14 more... | | Complete documentation |

**💡 Tip**: Each module README contains detailed usage examples, security considerations, and best practices.
