#define all security groups here so they can easily be hooked up to each other
resource "aws_security_group" "ecs_cluster" {
  name = "sg_ecs_cluster"
  description = "Only all inbound from ALB security groups"
  vpc_id = "${aws_vpc.services.id}"
}
#ECS Cluster's rules need not to be defined inline since it was causing a cycle
resource "aws_security_group_rule" "ecs_cluster_ingress" {
  type = "ingress"
  security_group_id = "${aws_security_group.ecs_cluster.id}"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = "${aws_security_group.external_alb.id}"
}
resource "aws_security_group_rule" "ecs_cluster_egress" {
  type = "egress"
  security_group_id = "${aws_security_group.ecs_cluster.id}"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
}

resource "aws_security_group" "internal_service_discovery" {
  name = "sg_internal_service_discovery"
  description = "Used for ECS cluster and internal alb. Allow only traffic to/from itself (default behavior for no rules)"
  vpc_id = "${aws_vpc.services.id}"
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self = true
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self = true
  }
}

resource "aws_security_group" "external_alb" {
  name = "sg_external_alb"
  description = "Inbound HTTP/HTTPS and outbound to ECS"
  vpc_id = "${aws_vpc.services.id}"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.ecs_cluster.id}"]
  }
}
