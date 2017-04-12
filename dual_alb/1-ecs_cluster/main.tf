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

variable "desired_cluster_size" {
  default = 2
}

#allow instances to talk with scheduler
resource "aws_iam_instance_profile" "ecs_instance" {
  name = "ecsInstanceProfile"
  roles = ["${aws_iam_role.ecs_instance.name}"]
}
resource "aws_iam_role" "ecs_instance" {
  name = "ecsInstanceRole"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
     "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs_instance_attachment" {
  role = "${aws_iam_role.ecs_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

output "ecs_cluster_id" {
	value = "${aws_ecs_cluster.dual_alb_poc.id}"
}
