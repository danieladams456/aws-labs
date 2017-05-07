terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key = "vpc_peering_alb_router/vpc18transit.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}


#outputs for use by other sub-projects
output "vpc_id" {
  value = "${aws_vpc.vpc18transit.id}"
}

#security groups


#subnets
output "subnet_public_us-east-1a" {
  value = "${aws_subnet.vpc18transit_public_us-east-1a.id}"
}
output "subnet_public_us-east-1b" {
  value = "${aws_subnet.vpc18transit_public_us-east-1b.id}"
}
output "subnet_public_us-east-1c" {
  value = "${aws_subnet.vpc18transit_public_us-east-1c.id}"
}
output "subnet_public_us-east-1d" {
  value = "${aws_subnet.vpc18transit_public_us-east-1d.id}"
}

output "subnet_private_us-east-1a" {
  value = "${aws_subnet.vpc18transit_private_us-east-1a.id}"
}
output "subnet_private_us-east-1b" {
  value = "${aws_subnet.vpc18transit_private_us-east-1b.id}"
}
output "subnet_private_us-east-1c" {
  value = "${aws_subnet.vpc18transit_private_us-east-1c.id}"
}
output "subnet_private_us-east-1d" {
  value = "${aws_subnet.vpc18transit_private_us-east-1d.id}"
}
