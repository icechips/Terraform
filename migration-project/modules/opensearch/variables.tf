#local module variables
locals {
  # Project Related Vars
  ClientName = "bakery"
  App        = "opensearch"
}

#build variables
variable "EnvName" {
  type        = string
  description = "Name of the Env"
}

variable "opensearch_engine_version" {
  type        = string
  description = "opensearch engine version"
}

variable "opensearch_instance_type" {
  type        = string
  description = "opensearch instance type"
}

variable "master_instance_type" {
  type        = string
  description = "master instance type"
}

variable "opensearch_instance_count" {
  type        = number
  description = "number of opensearch instances"
}

variable "multi_az" {
  type        = bool
  description = "Specifies if the installation will be Multi-AZ"
}

variable "master_enabled" {
  type        = bool
  description = "Specifies if the installation will have master nodes"
}

variable "opensearch_subnet_ids" {
  type        = list(string)
  description = "subnet ids for opensearch"
}

variable "opensearch_security_group_ids" {
  type        = list(string)
  description = "security groups associated with opensearch"
}

variable "opensearch_volume_size" {
  type        = number
  description = "volume size in GB for opensearch"
}

variable "opensearch_log_type" {
  type        = string
  description = "logging type for opensearch to push to cloudwatch"
}

/*variable "opensearch_policy_source_ip" {
  type        = list(string)
  description = "IPs allowed in opensearch domain policy"
}*/