resource "aws_alb_target_group" "webtier" {
  name     = "webtier-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-b64c98d0"
}

#attachments of ec2
resource "aws_alb_target_group_attachment" "webtier_webserver_b" {
  target_group_arn = "${aws_alb_target_group.webtier.arn}"
  target_id = "${aws_instance.webserver_b.id}"
  port = 80
}
resource "aws_alb_target_group_attachment" "webtier_webserver_c" {
  target_group_arn = "${aws_alb_target_group.webtier.arn}"
  target_id = "${aws_instance.webserver_c.id}"
  port = 80
}
