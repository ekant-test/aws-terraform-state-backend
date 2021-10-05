# Terraform State Backend

This project configures the terraform state backend to manage core AWS infrastructure. The backend is configured to use [AWS S3](https://www.terraform.io/docs/backends/types/s3.html) for state storage and DynamoDB for state locking during infrastructure provisioning. This project is part of the landing zone. It will follow a slightly different structure and workflow to regular terraform projects. Please ensure to read all information provided in this README before running or carrying out maintenance on this project.

The project will only create minimal resources to allow the landing zone to be run.

This template requires existing role in shared service account if not created by aws control tower.



## Usage

**IMPORTANT:** This terraform project must be run from the master account with credentials that allow administrative cross account access to the shared services account. The credentials must be allowed to assume IAM role configured in `cross_account_execution_role` which is located in the shared services account.The role has to be created manually in shared service account if not created by aws control tower.


Prepare the environment before terraform can be used to apply the infrastructure:

```sh
# name the region to operate in.
export AWS_DEFAULT_REGION=ap-southeast-2
# check you are in the master account with a suitable role
aws sts get-caller-identity
# name the cloud environment to operate in
export CLOUD_ID=awscloud
# activate the workspace for one of the configured environments
terraform init

```


Apply changes to the Terraform backend infrastructure configuration:

```sh
terraform apply
```

After applying terraform changes the new or modified terraform state files need to be checked into source control.

## Design

Because we cannot manage the terraform state backend resources within the same state backend, this project will use the default terraform file based state management.

The terraform state backend is created as part of the landing zone installation process.

The following resources are created as part of this project:

* KMS key to encrypt terraform state at rest
* a S3 bucket to host terraform state files
* a DynamoDB table used for ensuring terraform changes to a single workspace do not happen concurrently
* a IAM policy and role for the landing zone account (master) to use the terraform state backend
