terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key    = "sns_sqs/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
