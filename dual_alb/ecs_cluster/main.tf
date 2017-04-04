terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key = "dual_alb/ecs_cluster.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "base" {
  backend = "s3"
  config {
    bucket = "dadams-terraform_remote_state"
    key = "dual_alb/base.tfstate"
    region = "us-east-1"
  }
}

data "aws_vpc" "default" {
  default = true
}

variable "desired_cluster_size" {
  default = 0
}
