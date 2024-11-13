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
  description = "List of policy attachments"
  value = [
    for attachment in aws_organizations_policy_attachment.attach : {
      policy_name = split("-", attachment.id)[0]
      target_id   = attachment.target_id
      policy_id   = attachment.policy_id
    }
  ]
}