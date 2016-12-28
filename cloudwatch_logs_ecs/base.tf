provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "s3_state" {
  backend = "s3"
  config {
    bucket = "dadams-terraform_remote_state"
    key = "cloudwatch_logs_ecs/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_vpc" "default" {
  default = true
}
