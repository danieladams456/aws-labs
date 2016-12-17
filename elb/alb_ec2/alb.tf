data "aws_acm_certificate" "star_dadams_io" {
  domain = "*.dadams.io"
  statuses = ["ISSUED"]
}

#ALB definition, also need:
#listeners, listener_rules, target_groups, target_group_attachments
resource "aws_alb" "webtier" {
  name            = "webtier-alb"
  security_groups = ["sg-6e386a13","sg-95bbe7e8"] #default, http_https
  subnets         = ["subnet-c2a93def", "subnet-416c2b08"]  #AZ b and c

  tags {
    Environment = "Dev"
  }
}

resource "aws_alb_listener" "webtier_https" {
   load_balancer_arn = "${aws_alb.webtier.arn}"
   port = "443"
   protocol = "HTTPS"
   ssl_policy = "ELBSecurityPolicy-2015-05"
   certificate_arn = "${data.aws_acm_certificate.star_dadams_io.arn}"

   default_action {
     target_group_arn = "${aws_alb_target_group.webtier.arn}"
     type = "forward"
   }
}

resource "aws_alb_listener" "webtier_http" {
   load_balancer_arn = "${aws_alb.webtier.arn}"
   port = "80"
   protocol = "HTTP"

   default_action {
     target_group_arn = "${aws_alb_target_group.webtier.arn}"
     type = "forward"
   }
}
