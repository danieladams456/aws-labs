data "aws_acm_certificate" "star_dadams_io" {
  domain = "*.dadams.io"
  statuses = ["ISSUED"]
}

resource "aws_elb" "testelb" {
  name = "test-terraform-elb"
  availability_zones = ["us-east-1b", "us-east-1c"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.star_dadams_io.arn}"
  }

  health_check {
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  security_groups = ["sg-6e386a13","sg-95bbe7e8","sg-72b7eb0f"]

  instances = ["${aws_instance.webserver_b.id}","${aws_instance.webserver_c.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "foobar-terraform-elb"
  }
}
