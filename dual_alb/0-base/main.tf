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

data "aws_vpc" "default" {
  default = true
}

#define all security groups here so they can easily be hooked up to each other
resource "aws_security_group" "ecs_cluster" {
  name = "sg_ecs_cluster"
  description = "Only all inbound from ALB security groups"
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.external_alb.id}"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal_service_discovery" {
  name = "sg_internal_service_discovery"
  description = "Used for ECS cluster and internal alb. Allow only traffic to/from itself (default behavior for no rules)"
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self = true
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self = true
  }
}

resource "aws_security_group" "external_alb" {
  name = "sg_external_alb"
  description = "Only all inbound from ALB security groups"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.internal_service_discovery.id}"]
  }
}

#define subnets to launch instances in/tie to ALBs
data "aws_subnet" "subnet_us-east-1a" {
  availability_zone = "us-east-1a"
  default_for_az = true
}
data "aws_subnet" "subnet_us-east-1b" {
  availability_zone = "us-east-1b"
  default_for_az = true
}

#outputs for use by other sub-projects
output "vpc_id" {
  value = "${data.aws_vpc.default.id}"
}
output "sg_ecs_cluster_id" {
  value = "${aws_security_group.ecs_cluster.id}"
}
output "sg_internal_service_discovery_id" {
  value = "${aws_security_group.internal_service_discovery.id}"
}
output "sg_external_alb_id" {
  value = "${aws_security_group.external_alb.id}"
}
output "subnet_us-east-1a" {
  value = "${data.aws_subnet.subnet_us-east-1a.id}"
}
output "subnet_us-east-1b" {
  value = "${data.aws_subnet.subnet_us-east-1b.id}"
}
