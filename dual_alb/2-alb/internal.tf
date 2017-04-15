#ALB definition, also need:
#listeners, listener_rules, target_groups, target_group_attachments
resource "aws_alb" "internal" {
  name = "alb-internal"
  internal = true
  security_groups = ["${data.terraform_remote_state.vpc.sg_internal_service_discovery_id}"]
  subnets = ["${data.terraform_remote_state.vpc.subnet_private_us-east-1a}",
             "${data.terraform_remote_state.vpc.subnet_private_us-east-1b}",
             "${data.terraform_remote_state.vpc.subnet_private_us-east-1c}",
             "${data.terraform_remote_state.vpc.subnet_private_us-east-1d}"]
}

resource "aws_alb_listener" "internal_http" {
   load_balancer_arn = "${aws_alb.internal.arn}"
   port = "80"
   protocol = "HTTP"

   default_action {
     target_group_arn = "${aws_alb_target_group.default_internal.arn}"
     type = "forward"
   }
}

resource "aws_alb_target_group" "default_internal" {
  name = "default-internal"
  port = 80
  protocol = "HTTP"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_route53_record" "services_internal" {
  zone_id = "${data.aws_route53_zone.dadams_io.id}"
  name = "services.internal.dadams.io"
  type = "A"
  alias {
    name = "${aws_alb.internal.dns_name}"
    zone_id = "${aws_alb.internal.zone_id}"
    evaluate_target_health = false
  }
}
