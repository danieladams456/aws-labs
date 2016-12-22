resource "aws_ecs_service" "test1" {
  name = "test1"
  cluster = "${var.cluster_arn}"
  task_definition = "${var.task_arn}"
  iam_role = "${var.ecs_service_role_arn}"
  desired_count = 20

  #TODO this has to be a terraform object I think, not an arn
  #depends_on = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs-service-test1.arn}"
    container_name = "simple-app"
    container_port = 80
  }
}
