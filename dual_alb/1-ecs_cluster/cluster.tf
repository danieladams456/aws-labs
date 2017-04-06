resource "aws_ecs_cluster" "dual_alb_poc" {
  name = "dual_alb_poc"
}

resource "aws_launch_configuration" "ecs_dual_alb_poc_cluster_instance" {
  name_prefix = "ecs_dual_alb_poc_cluster_instance-"
  image_id = "ami-275ffe31"
  instance_type = "t2.micro"
  security_groups = ["${data.terraform_remote_state.base.sg_ecs_cluster_id}",
                     "${data.terraform_remote_state.base.sg_internal_service_discovery_id}"]
  enable_monitoring = false #save some $ here
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.dual_alb_poc.name} >> /etc/ecs/ecs.config
EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_dual_alb_poc_cluster" {
  vpc_zone_identifier = ["${data.terraform_remote_state.base.subnet_us-east-1a}",
                         "${data.terraform_remote_state.base.subnet_us-east-1b}"]
  name = "ecs_dual_alb_poc_cluster"
  launch_configuration = "${aws_launch_configuration.ecs_dual_alb_poc_cluster_instance.name}"

  min_size = 0
  max_size = 4
  desired_capacity = "${var.desired_cluster_size}"

  health_check_grace_period = 300
  health_check_type = "EC2"
  termination_policies = ["ClosestToNextInstanceHour"]
  lifecycle {
    create_before_destroy = true
  }
}
