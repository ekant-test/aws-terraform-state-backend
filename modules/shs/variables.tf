
variable "cloud_id" {
  type        = string
  description = "a unique id used for the cloud instance in which the resources are placed"
}

variable "master_account_id" {
  type        = string
  description = "the AWS account id of the master account that will be hosting the landing zone"
}

variable "common_tags" {
  type        = map(string)
  description = "the common tags to apply to the managed resources"
}

variable "state_bucket_versioning" {
  type        = bool
  description = "Enable versioning of the Terraform state files in the S3 state bucket."
}
