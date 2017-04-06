data "aws_acm_certificate" "star_dadams_io" {
  domain = "*.dadams.io"
  statuses = ["ISSUED"]
}

#ALB definition, also need:
#listeners, listener_rules, target_groups, target_group_attachments
resource "aws_alb" "external" {
  name = "alb-external"
  security_groups = ["${data.terraform_remote_state.base.sg_external_alb_id}"]
  subnets = ["${data.terraform_remote_state.base.subnet_us-east-1a}",
             "${data.terraform_remote_state.base.subnet_us-east-1b}"]
}

resource "aws_alb_listener" "external_https" {
   load_balancer_arn = "${aws_alb.external.arn}"
   port = "443"
   protocol = "HTTPS"
   ssl_policy = "ELBSecurityPolicy-2015-05"
   certificate_arn = "${data.aws_acm_certificate.star_dadams_io.arn}"

   default_action {
     target_group_arn = "${aws_alb_target_group.default_external_https.arn}"
     type = "forward"
   }
}

resource "aws_alb_listener" "external_http" {
   load_balancer_arn = "${aws_alb.external.arn}"
   port = "80"
   protocol = "HTTP"

   default_action {
     target_group_arn = "${aws_alb_target_group.default_external_http.arn}"
     type = "forward"
   }
}

resource "aws_alb_target_group" "default_external-http" {
  name = "default-external-http"
  port = 80
  protocol = "HTTP"
  vpc_id = "${data.terraform_remote_state.base.vpc_id}"
}
resource "aws_alb_target_group" "default_external-https" {
  name = "default-external-https"
  port = 80
  protocol = "HTTP"
  vpc_id = "${data.terraform_remote_state.base.vpc_id}"
}

resource "aws_route53_record" "services" {
  zone_id = "${data.aws_route53_zone.dadams_io.id}"
  name = "services.dadams.io"
  type = "A"
  alias {
    name = "${aws_alb.external.dns_name}"
    zone_id = "${aws_alb.external.zone_id}"
    evaluate_target_health = false
  }
}
