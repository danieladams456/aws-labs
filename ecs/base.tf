provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "s3_state" {
  backend = "s3"
  config {
    bucket = "dadams-terraform_remote_state"
    key = "ecs/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_vpc" "default" {
  default = true
}

variable "cluster_arn" {}
variable "task_arn" {}
variable "ecs_service_role_arn" {}
