provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "s3_state" {
  backend = "s3"
  config {
    bucket = "dadams-terraform_remote_state"
    key = "elb/alb-ec2/terraform.tfstate"
    region = "us-east-1"
  }
}
