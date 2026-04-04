output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}

output "acm_certificate_domain_validation_options" {
  description = "A list of attributes to feed into other resources to complete certificate validation"
  value       = module.acm.acm_certificate_domain_validation_options
}

output "acm_certificate_status" {
  description = "Status of the certificate"
  value       = module.acm.acm_certificate_status
}

output "acm_certificate_validation_emails" {
  description = "A list of addresses that received a validation email"
  value       = module.acm.acm_certificate_validation_emails
}

output "distinct_domain_names" {
  description = "List of distinct domains names used for the validation"
  value       = module.acm.distinct_domain_names
}

output "validation_domains" {
  description = "List of distinct domain validation options"
  value       = module.acm.validation_domains
}

output "validation_route53_record_fqdns" {
  description = "List of FQDNs built using the zone domain and target resource record"
  value       = module.acm.validation_route53_record_fqdns
}
