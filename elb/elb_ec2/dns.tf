variable "aws_route53_default_zoneid" {
  default = "ZEMD7XEJVSLN3"
}
resource "aws_route53_record" "www" {
  zone_id = "${var.aws_route53_default_zoneid}"
  name = "testelb.dadams.io"
  type = "A"

  alias {
    name = "${aws_elb.testelb.dns_name}"
    zone_id = "${aws_elb.testelb.zone_id}"
    evaluate_target_health = true
  }
}
