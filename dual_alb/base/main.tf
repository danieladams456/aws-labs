terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key = "dual_alb/base.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}


#security group with no ingress rules, it will just be used for a target of other security groups
resource "aws_security_group" "ecs_cluster" {
  name = "sg_ecs_cluster"
  description = "Only all inbound from ALB security groups"
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#put other security groups here so they can easily be hooked up
