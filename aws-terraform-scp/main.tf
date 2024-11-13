locals {
  # Convert list to map for resource creation
  policies_map = { for policy in var.policies : policy.name => policy }
  
  # Flatten policy-target combinations for attachments
  policy_attachments = flatten([
    for policy in var.policies : [
      for target in policy.target_ids : {
        policy_name = policy.name
        target_id   = target
      }
    ]
  ])
}

resource "aws_organizations_policy" "scp" {
  for_each    = local.policies_map
  
  name        = each.value.name
  description = each.value.description
  content     = file(each.value.content)  # Now reading from file path
  type        = "SERVICE_CONTROL_POLICY"
  
  tags = var.tags
}

resource "aws_organizations_policy_attachment" "attach" {
  for_each = {
    for idx, attachment in local.policy_attachments : 
    "${attachment.policy_name}-${attachment.target_id}" => attachment
  }
  
  policy_id = aws_organizations_policy.scp[each.value.policy_name].id
  target_id = each.value.target_id
}