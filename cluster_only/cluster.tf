resource "aws_ecs_cluster" "default" {
  name = "default"
}

resource "aws_launch_configuration" "ecs_default_cluster_instance" {
  name = "ecs_default_cluster_instance"
  image_id = "ami-fbacaaec"
  instance_type = "t2.micro"
  security_groups = ["sg-6e386a13"] #default VPC security group
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"
}
 
resource "aws_autoscaling_group" "ecs_default_cluster" {
  availability_zones = ["us-east-1b", "us-east-1c"]
  name = "ecs_default_cluster"
  launch_configuration = "${aws_launch_configuration.ecs_default_cluster_instance.name}"
 
  min_size = 0
  max_size = 4
  desired_capacity = "${var.desired_cluster_size}"
 
  health_check_grace_period = 300
  health_check_type = "EC2"
  termination_policies = ["ClosestToNextInstanceHour"]
}
