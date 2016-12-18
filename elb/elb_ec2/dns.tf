data "aws_route53_zone" "dadams_io" {
  name = "dadams.io."
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.dadams_io.zone_id}"
  name = "testelb.dadams.io"
  type = "A"

  alias {
    name = "${aws_elb.testelb.dns_name}"
    zone_id = "${aws_elb.testelb.zone_id}"
    evaluate_target_health = true
  }
}
