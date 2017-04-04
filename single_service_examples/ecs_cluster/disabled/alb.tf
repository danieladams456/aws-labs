data "aws_acm_certificate" "dadams_io" {
  domain = "dadams.io"
  statuses = ["ISSUED"]
}

resource "aws_alb" "main" {
  name            = "main"
  security_groups = ["sg-6e386a13","sg-95bbe7e8"] #default, http_https
  subnets         = ["subnet-c2a93def", "subnet-416c2b08"]  #AZ b and c
}

resource "aws_alb_listener" "main_https" {
   load_balancer_arn = "${aws_alb.main.arn}"
   port = "443"
   protocol = "HTTPS"
   ssl_policy = "ELBSecurityPolicy-2015-05"
   certificate_arn = "${data.aws_acm_certificate.dadams_io.arn}"

   default_action {
     target_group_arn = "${aws_alb_target_group.ecs-service-default-landing-page.arn}"
     type = "forward"
   }
}

resource "aws_alb_listener" "main_http" {
   load_balancer_arn = "${aws_alb.main.arn}"
   port = "80"
   protocol = "HTTP"

   default_action {
     target_group_arn = "${aws_alb_target_group.ecs-service-default-landing-page.arn}"
     type = "forward"
   }
}

resource "aws_alb_target_group" "ecs-service-default-landing-page" {
  name = "ecs-service-default-landing-page"
  vpc_id = "${data.aws_vpc.default.id}"
  port = "80"
  protocol = "HTTP"
}

resource "aws_alb_target_group" "ecs-service-nginx-app" {
  name = "ecs-service-nginx-app"
  vpc_id = "${data.aws_vpc.default.id}"
  port = "80"
  protocol = "HTTP"
}

resource "aws_alb_listener_rule" "http_nginx" {
  listener_arn = "${aws_alb_listener.main_http.arn}"
  priority = 100

  action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.ecs-service-nginx-app.arn}"
  }

  condition {
    field = "path-pattern"
    values = ["/nginx*"]
  }
}

resource "aws_alb_listener_rule" "https_nginx" {
  listener_arn = "${aws_alb_listener.main_https.arn}"
  priority = 100

  action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.ecs-service-nginx-app.arn}"
  }

  condition {
    field = "path-pattern"
    values = ["/nginx*"]
  }
}
