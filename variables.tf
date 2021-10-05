
# -- landing zone execution ----------------------------------------------------

variable "cloud_id" {
  type        = string
  description = "a unique id used for the cloud instance in which the resources are placed"
}

variable "cross_account_execution_role" {
  type        = string
  description = "the name of the cross account execution role used to configure accounts within the orgainsational structure."
  default     = "AWSControlTowerExecution"
}

variable "shs_account_id" {
  type        = string
  description = "the AWS account id of the shared services account holding the terraform state resources"
}

variable "master_account_id" {
  type        = string
  description = "the AWS account id of the master account that will be hosting the landing zone"
}

# -- terraform state bucket setup ----------------------------------------------

variable "state_bucket_versioning" {
  type        = bool
  description = "Enable versioning of the Terraform state files in the S3 state bucket."
  default     = false
}
