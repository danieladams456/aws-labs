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

variable "task_arn1" {}
variable "task_arn2" {}
variable "desired_cluster_size" {
  default = 1
}

data "aws_vpc" "default" {
  default = true
}
