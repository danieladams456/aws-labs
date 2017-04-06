terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key = "dual_alb/ecs_tasks.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

#dont' know if this is needed here yet
// data "terraform_remote_state" "base" {
//   backend = "s3"
//   config {
//     bucket = "dadams-terraform_remote_state"
//     key = "dual_alb/base.tfstate"
//     region = "us-east-1"
//   }
// }

#allow service to talk with ALB
resource "aws_iam_role" "ecs_service" {
  name = "ecsServiceRole"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
     "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs_service_attachment" {
  role = "${aws_iam_role.ecs_service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
