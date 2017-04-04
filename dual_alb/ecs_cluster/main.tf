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
