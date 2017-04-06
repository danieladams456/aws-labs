terraform {
  backend "s3" {
    bucket = "dadams-terraform_remote_state"
    key = "dual_alb/alb.tfstate"
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

data "aws_route53_zone" "dadams_io" {
  name = "dadams.io."
}

#outputs so other projects can hook into the load balancer
output "alb_internal_id" {
	value = "${aws_alb.internal.id}"
}
output "alb_external_id" {
	value = "${aws_alb.external.id}"
}
output "default_target_external_https" {
	value = "${aws_alb_listener.external_https.id}"
}
output "default_target_external_http" {
	value = "${aws_alb_listener.external_http.id}"
}
