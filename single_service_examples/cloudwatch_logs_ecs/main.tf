terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key    = "cloudwatch_logs_ecs/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}
