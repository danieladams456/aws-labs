variable "ecs_cluster_arn" {}

resource "aws_ecs_service" "cloudwatch_logs_test" {
  name = "cloudwatch_logs_test"
  cluster = "${var.ecs_cluster_arn}"
  task_definition = "${aws_ecs_task_definition.nginx_hostname.id}"
  desired_count = 2

  iam_role = "${aws_iam_role.ecs_service.id}"
  depends_on = ["aws_iam_role.ecs_service"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs-service-cloudwatch-logs-test.arn}"
    container_name = "nginxhostname"
    container_port = 80
  }
}
