terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key    = "ecs/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "desired_cluster_size" {
  default = 1
}

data "aws_vpc" "default" {
  default = true
}
