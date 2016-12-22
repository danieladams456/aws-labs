data "aws_route53_zone" "dadams_io" {
  name = "dadams.io."
}

resource "aws_route53_record" "root_alias" {
  zone_id = "${data.aws_route53_zone.dadams_io.zone_id}"
  name = "dadams.io"
  type = "A"

  alias {
    name = "${aws_alb.main.dns_name}"
    zone_id = "${aws_alb.main.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_alias" {
  zone_id = "${data.aws_route53_zone.dadams_io.zone_id}"
  name = "www.dadams.io"
  type = "A"

  alias {
    name = "${aws_alb.main.dns_name}"
    zone_id = "${aws_alb.main.zone_id}"
    evaluate_target_health = false
  }
}
