output "cloudtrail_arn" {
  description = "The ARN of the CloudTrail trail"
  value       = module.cloudtrail.cloudtrail_arn
}

output "cloudtrail_home_region" {
  description = "The region in which the trail was created"
  value       = module.cloudtrail.cloudtrail_home_region
}

output "cloudtrail_id" {
  description = "The name of the CloudTrail trail"
  value       = module.cloudtrail.cloudtrail_id
}
