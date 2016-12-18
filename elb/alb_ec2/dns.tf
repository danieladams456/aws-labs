data "aws_route53_zone" "dadams_io" {
  name = "dadams.io."
}

resource "aws_route53_record" "testalb" {
  zone_id = "${data.aws_route53_zone.dadams_io.zone_id}"
  name = "testalb.dadams.io"
  type = "A"

  alias {
    name = "${aws_alb.webtier.dns_name}"
    zone_id = "${aws_alb.webtier.zone_id}"
    evaluate_target_health = true
  }
}
