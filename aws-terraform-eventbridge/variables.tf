variable "api_destinations" {
  description = "A map of objects with EventBridge Destination definitions"
  type = map(any)
  default = {}
}

variable "append_connection_postfix" {
  description = "Controls whether to append '-connection' to the name of the connection"
  type = bool
    default = true
}

variable "append_destination_postfix" {
  description = "Controls whether to append '-destination' to the name of the destination"
  type = bool
    default = true
}

variable "append_pipe_postfix" {
  description = "Controls whether to append '-pipe' to the name of the pipe"
  type = bool
    default = true
}

variable "append_rule_postfix" {
  description = "Controls whether to append '-rule' to the name of the rule"
  type = bool
    default = true
}

variable "append_schedule_group_postfix" {
  description = "Controls whether to append '-schedule-group' to the name of the schedule group"
  type = bool
    default = true
}

variable "append_schedule_postfix" {
  description = "Controls whether to append '-schedule' to the name of the schedule"
  type = bool
    default = true  
}

variable "archives" {
  description = "A map of objects with EventBridge Archive definitions"
  type = map(any)
  default = {}
}

variable "attach_api_destination_policy" {
  description = "Controls whether to attach a policy to the API Destination"
  type = bool
  default = false
}

variable "attach_cloudwatch_policy" {
  description = "Controls whether to attach a policy to the CloudWatch target"
  type = bool
  default = false
}

variable "attach_ecs_policy" {
  description = "Controls whether to attach a policy to the ECS target"
  type = bool
  default = false
}

variable "attach_kinesis_firehose_policy" {
  description = "Controls whether to attach a policy to the Kinesis Firehose target"
  type = bool
  default = false
}

variable "attach_lambda_policy" {
  description = "Controls whether to attach a policy to the Lambda target"
  type = bool
  default = false
}

variable "attach_policies" {
  description = "Controls whether list of policies should be added to IAM role"
    type = bool
    default = false
}

variable "attach_policy" {
  description = "Controls whether a policy should be added to IAM role"
    type = bool
    default = false
}

variable "attach_policy_json" {
  description = "Controls whether a policy should be added to IAM role"
    type = bool
    default = false
}

variable "attach_policy_statements" {
  description = "Controls whether a policy should be added to IAM role"
    type = bool
    default = false
}

variable "attach_sfn_policy" {
  description = "Controls whether to attach a policy to the Step Functions target"
  type = bool
  default = false
}

variable "attach_sns_policy" {
  description = "Controls whether to attach a policy to the SNS target"
  type = bool
  default = false   
}

variable "attach_sqs_policy" {
  description = "Controls whether to attach a policy to the SQS target"
  type = bool
  default = false
}

variable "attach_tracing_policy" {
  description = "Controls whether to attach a policy to the Tracing target"
  type = bool
  default = false
}

variable "bus_name" {
  description = "A unique name for your EventBridge Bus"
    type = string
    default = "default"
}

variable "cloudwatch_target_arns" {
  description = "A map of CloudWatch target ARNs"
  type = list(string)
  default = []
}

variable "connections" {
  description = "A map of objects with EventBridge Connection definitions"
  type = any
  default = {}
}

variable "create" {
  description = "Controls whether to create the EventBridge resources"
  type = bool
  default = true
}

variable "create_api_destinations" {
  description = "Controls whether to create the API Destinations"
  type = bool
  default = false
}

variable "create_archives" {
  description = "Controls whether to create the Archives"
  type = bool
  default = false
}

variable "create_connections" {
  description = "Controls whether EventBridge Connection resources should be created"
    type = bool
    default = true
}

variable "create_permissions" {
  description = "Controls whether EventBridge Permission resources should be created"
    type = bool
    default = true
}

variable "create_pipes" {
  description = "Controls whether to create the Pipes"
  type = bool
  default = true
}

variable "create_role" {
  description = "Controls whether to create the IAM role"
  type = bool
  default = true
}

variable "create_rules" {
  description = "Controls whether to create the Rules"
  type = bool
  default = true
}

variable "create_schedule_groups" {
  description = "Controls whether to create the Schedule Groups"
  type = bool
  default = true
}

variable "create_schedules" {
  description = "Controls whether to create the Schedules"
    type = bool 
    default = true
}

variable "create_schemas_discoverer" {
  description = "Controls whether to create the Schemas Discoverer"
  type = bool
  default = false
}

variable "create_targets" {
  description = "Controls whether to create the Targets"
  type = bool
  default = true
}

variable "ecs_pass_role_resources" {
  description = "A map of ECS Pass Role resources"
  type = list(string)
  default = []
}

variable "ecs_target_arns" {
  description = "A map of ECS target ARNs"
  type = list(string)
  default = []
}

variable "event_source_name" {
  description = "The name of the event source"
  type = string
  default = ""
}

variable "kinesis_firehose_target_arns" {
  description = "A map of Kinesis Firehose target ARNs"
  type = list(string)
  default = []
}

variable "kinesis_target_arns" {
  description = "A map of Kinesis target ARNs"
  type = list(string)
  default = []
}

variable "kms_key_identifier" {
  description = "The ARN of the KMS key used to encrypt the data"
  type = string
  default = null  
}

variable "lambda_target_arns" {
  description = "A map of Lambda function ARNs"
  type = list(string)
  default = []
}

variable "number_of_policies" {
  description = "The number of policies to create"
  type = number
  default = 0
}

variable "number_of_policy_jsons" {
  description = "The number of policy JSONs to create"
  type = number
  default = 0
}

variable "permissions" {
  description = "A map of objects with EventBridge Permission definitions"
  type = map(any)
  default = {}
}

variable "pipes" {
  description = "A map of objects with EventBridge Pipe definitions"
  type = any
  default = {}
}

variable "policies" {
  description = "A map of objects with IAM policy definitions"
  type = list(string)
  default = []
}

variable "policy" {
  description = "A map of objects with IAM policy definitions"
  type = string
  default = null
}

variable "policy_json" {
  description = "A map of objects with IAM policy JSON definitions"
  type = string
  default = null    
}

variable "policy_jsons" {
  description = "A map of objects with IAM policy JSON definitions"
  type = list(string)
  default = []
}

variable "policy_path" {
  description = "The path for the policy"
  type = string
  default = null
}

variable "policy_statements" {
  description = "A map of objects with IAM policy statement definitions"
  type = any
  default = {}
}

variable "role_description" {
  description = "The description of the IAM role"
  type = string
  default = null
}

variable "role_force_detach_policies" {
  description = "Controls whether to force detach policies from the IAM role"
  type = bool
  default = true
}

variable "role_name" {
  description = "Name of IAM role to use for EventBridge"
    type = string
    default = "eventbridge-role"
}

variable "role_path" {
  description = "The path for the IAM role"
  type = string
  default = null
}

variable "role_permissions_boundary" {
  description = "The ARN of the permissions boundary policy"
  type = string
  default = null
}

variable "role_tags" {
  description = "A map of tags to add to the IAM role"
  type = map(string)
  default = {}
}

variable "rules" {
  description = "A map of objects with EventBridge Rule definitions"
  type = map(any)
  default = {}
}

variable "schedule_group_timeouts" {
  description = "A map of objects with EventBridge Schedule Group create and delete timeouts."
  default = {}
}

variable "schedule_groups" {
  description = "A map of objects with EventBridge Schedule Group definitions"
  type = any
  default = {}
}

variable "schedules" {
  description = "A map of objects with EventBridge Schedule definitions"
  type = map(any)
  default = {}
}

variable "schemas_discoverer_description" {
  description = "The description of the Schemas Discoverer"
  type = string
  default = null
}

variable "sfn_target_arns" {
  description = "A map of Step Functions target ARNs"
  type = list(string)
  default = []
}

variable "sns_kms_arns" {
  description = "A map of SNS KMS ARNs"
  type = list(string)
  default = []
}

variable "sqs_target_arns" {
  description = "A map of SQS target ARNs"
  type = list(string)
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
  default = {}
}

variable "targets" {
  description = "A map of objects with EventBridge Target definitions"
  type = any
  default = {}
}

variable "trusted_entities" {
  description = "A map of trusted entities"
  type = list(string)
  default = []
}

variable "sns_target_arns" {
  description = "A map of SNS target ARNs"
  type = list(string)
  default = [] 
}

variable "create_bus" {
  description = "Controls whether EventBridge Bus resource should be created"
  type = bool
    default = true
}

variable "attach_kinesis_policy" {
  description = "Controls whether the Kinesis policy should be added to IAM role for EventBridge Target"
    type = bool
    default = false
}

