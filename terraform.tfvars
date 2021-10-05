# configure variables defining the environment
cloud_id = "ekant"

# the account that the landing zone is executed in
master_account_id = "xxxxxxxxxxxxx"

# the account hosting the terraform state configuration(shared service account)
shs_account_id = "xxxxxxxxxxxxx"

# If control tower is not enabled in the AWS account so need to create this role
cross_account_execution_role = "OrganizationAccountAccessRole"

# terraform configuration
state_bucket_versioning = true
