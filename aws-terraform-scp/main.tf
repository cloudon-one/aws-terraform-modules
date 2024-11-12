resource "aws_organizations_policy" "scp" {
  for_each    = var.policies
  
  name        = each.value.name
  description = each.value.description
  content     = each.value.content
  type        = "SERVICE_CONTROL_POLICY"
  
  tags = var.tags
}

resource "aws_organizations_policy_attachment" "attach" {
  for_each = {
    for pair in flatten([
      for policy_key, policy in var.policies : [
        for target in policy.target_ids : {
          policy_key = policy_key
          target_id  = target
        }
      ]
    ]) : "${pair.policy_key}-${pair.target_id}" => pair
  }
  
  policy_id = aws_organizations_policy.scp[each.value.policy_key].id
  target_id = each.value.target_id
}
