resource "aws_ecs_service" "test1" {
  name = "test1"
  cluster = "${aws_ecs_cluster.default.id}"
  task_definition = "${var.task_arn}"
  desired_count = 2

  iam_role = "${aws_iam_role.ecs_service.id}"
  depends_on = ["aws_iam_role.ecs_service"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs-service-test1.arn}"
    container_name = "simple-app"
    container_port = 80
  }
}
