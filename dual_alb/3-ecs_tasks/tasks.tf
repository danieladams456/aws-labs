resource "aws_ecs_service" "redirect_to_https" {
  name = "redirect_to_https"
  cluster = "${data.terraform_remote_state.ecs_cluster.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.redirect_to_https.id}"
  desired_count = 2

  // iam_role = "${aws_iam_role.ecs_service.id}"
  // depends_on = ["aws_iam_role.ecs_service"]
  //
  // load_balancer {
  //   target_group_arn = "${data.terraform_remote_state.alb.default_target_external_http}"
  //   container_name = "redirect"
  //   container_port = 8080
  // }
}

resource "aws_ecs_task_definition" "redirect_to_https" {
	family = "redirect_to_https"
	container_definitions = "${file("data/task_redirect_to_https.json")}"
}
