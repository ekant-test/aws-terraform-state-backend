terraform {

  required_version = "~> 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22.0"
    }
  }

}

provider "aws" {
  alias = "shs"
  assume_role {
    role_arn = "arn:aws:iam::${var.shs_account_id}:role/${var.cross_account_execution_role}"
  }
}
