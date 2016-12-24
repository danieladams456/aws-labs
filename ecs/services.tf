resource "aws_ecs_service" "default_landing_page" {
  name = "default_landing_page"
  cluster = "${aws_ecs_cluster.default.id}"
  task_definition = "${var.task_arn1}"
  desired_count = 1

  iam_role = "${aws_iam_role.ecs_service.id}"
  depends_on = ["aws_iam_role.ecs_service"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs-service-default-landing-page.arn}"
    container_name = "simple-app"
    container_port = 80
  }
}

resource "aws_ecs_service" "nginx_app" {
  name = "nginx_alpine"
  cluster = "${aws_ecs_cluster.default.id}"
  task_definition = "${var.task_arn2}"
  desired_count = 2

  iam_role = "${aws_iam_role.ecs_service.id}"
  depends_on = ["aws_iam_role.ecs_service"]
  
  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs-service-nginx-app.arn}"
    container_name = "nginx-alpine"
    container_port = 80
  }
}
