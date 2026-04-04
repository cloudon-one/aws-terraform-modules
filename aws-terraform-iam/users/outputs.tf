output "iam_access_key_encrypted_secret" {
  description = "The encrypted secret, base64 encoded, if pgp_key was specified"
  value       = module.iam_iam-user.iam_access_key_encrypted_secret
  sensitive   = true
}

output "iam_access_key_encrypted_ses_smtp_password_v4" {
  description = "The encrypted SES SMTP password, base64 encoded, if pgp_key was specified"
  value       = module.iam_iam-user.iam_access_key_encrypted_ses_smtp_password_v4
  sensitive   = true
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.iam_iam-user.iam_access_key_id
}

output "iam_access_key_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the secret"
  value       = module.iam_iam-user.iam_access_key_key_fingerprint
}

output "iam_access_key_secret" {
  description = "The access key secret"
  value       = module.iam_iam-user.iam_access_key_secret
  sensitive   = true
}

output "iam_user_arn" {
  description = "The ARN of the IAM user"
  value       = module.iam_iam-user.iam_user_arn
}

output "iam_user_name" {
  description = "The name of the IAM user"
  value       = module.iam_iam-user.iam_user_name
}

output "policy_arns" {
  description = "The list of ARNs of policies attached to the IAM user"
  value       = module.iam_iam-user.policy_arns
}
