terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key = "vpc_peering_alb_router/peering.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

####  Remote state for vpcs to peer  ##################################
data "terraform_remote_state" "vpc18transit" {
  backend = "s3"
  config {
    bucket = "dadams-terraform_remote_state"
    key = "vpc_peering_alb_router/vpc18transit.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "vpc19" {
  backend = "s3"
  config {
    bucket = "dadams-terraform_remote_state"
    key = "vpc_peering_alb_router/vpc19.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "vpc20" {
  backend = "s3"
  config {
    bucket = "dadams-terraform_remote_state"
    key = "vpc_peering_alb_router/vpc20.tfstate"
    region = "us-east-1"
  }
}
