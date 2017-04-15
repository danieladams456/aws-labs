terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key = "dual_alb/vpc.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}


#outputs for use by other sub-projects
output "vpc_id" {
  value = "${aws_vpc.services.id}"
}

#security groups
output "sg_ecs_cluster_id" {
  value = "${aws_security_group.ecs_cluster.id}"
}
output "sg_internal_service_discovery_id" {
  value = "${aws_security_group.internal_service_discovery.id}"
}
output "sg_external_alb_id" {
  value = "${aws_security_group.external_alb.id}"
}

#subnets
output "subnet_public_us-east-1a" {
  value = "${aws_subnet.services_public_us-east-1a.id}"
}
output "subnet_public_us-east-1b" {
  value = "${aws_subnet.services_public_us-east-1b.id}"
}
output "subnet_public_us-east-1c" {
  value = "${aws_subnet.services_public_us-east-1c.id}"
}
output "subnet_public_us-east-1d" {
  value = "${aws_subnet.services_public_us-east-1d.id}"
}

output "subnet_private_us-east-1a" {
  value = "${aws_subnet.services_private_us-east-1a.id}"
}
output "subnet_private_us-east-1b" {
  value = "${aws_subnet.services_private_us-east-1b.id}"
}
output "subnet_private_us-east-1c" {
  value = "${aws_subnet.services_private_us-east-1c.id}"
}
output "subnet_private_us-east-1d" {
  value = "${aws_subnet.services_private_us-east-1d.id}"
}
