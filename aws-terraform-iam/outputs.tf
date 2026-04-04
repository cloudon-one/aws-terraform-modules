# This is a top-level outputs file for the IAM module
# Individual sub-modules have their own outputs

output "module_info" {
  description = "Information about available IAM sub-modules"
  value = {
    available_modules = [
      "policies",
      "users"
    ]
    description = "Use these sub-modules individually based on your needs"
  }
}

# Example usage information
output "usage_example" {
  description = "Example usage for IAM sub-modules"
  value       = <<-EOT
    # Use individual sub-modules like this:

    module "iam_users" {
      source = "./aws-terraform-iam/users"
      # user configuration
    }

    module "iam_policies" {
      source = "./aws-terraform-iam/policies"
      # policy configuration
    }
  EOT
}
