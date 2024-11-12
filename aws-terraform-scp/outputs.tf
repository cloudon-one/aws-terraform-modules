output "policy_ids" {
  description = "Map of policy names to their IDs"
  value = {
    for key, policy in aws_organizations_policy.scp : key => policy.id
  }
}

output "policy_arns" {
  description = "Map of policy names to their ARNs"
  value = {
    for key, policy in aws_organizations_policy.scp : key => policy.arn
  }
}

output "attachments" {
  description = "Map of policy attachments"
  value = {
    for key, attachment in aws_organizations_policy_attachment.attach : key => {
      policy_id = attachment.policy_id
      target_id = attachment.target_id
    }
  }
}