resource "aws_ecs_task_definition" "nginx_hostname" {
  family = "nginx_hostname"
  container_definitions = "${file("task_definitions/nginx_hostname.json")}"
}
