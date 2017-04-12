# Task definitions
resource "aws_ecs_task_definition" "redirect_service" {
	family = "redirect_service"
	container_definitions = "${file("data/redirect_service.json")}"
}
resource "aws_ecs_task_definition" "console_app" {
  family = "console_app"
	container_definitions = "${file("data/console_app.json")}"
}
resource "aws_ecs_task_definition" "stock_service" {
  family = "stock_service"
	container_definitions = "${file("data/stock_service.json")}"
}
resource "aws_ecs_task_definition" "weather_service" {
  family = "weather_service"
	container_definitions = "${file("data/weather_service.json")}"
}


# Services
resource "aws_ecs_service" "redirect_service" {
  name = "redirect_service"
  cluster = "${data.terraform_remote_state.ecs_cluster.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.redirect_service.id}"
  desired_count = 2

  iam_role = "${aws_iam_role.ecs_service.name}"
  depends_on = ["aws_iam_role.ecs_service"]

  load_balancer {
    target_group_arn = "${data.terraform_remote_state.alb.default_target_external_http_id}"
    container_name = "redirect"
    container_port = 8080
  }
}

resource "aws_ecs_service" "console_app" {
  name = "console_app"
  cluster = "${data.terraform_remote_state.ecs_cluster.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.console_app.id}"
  desired_count = 2

  iam_role = "${aws_iam_role.ecs_service.name}"
  depends_on = ["aws_iam_role.ecs_service"]

  load_balancer {
    target_group_arn = "${data.terraform_remote_state.alb.default_target_external_https_id}"
    container_name = "console"
    container_port = 5000
  }
}

resource "aws_ecs_service" "weather_service" {
  name = "weather_service"
  cluster = "${data.terraform_remote_state.ecs_cluster.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.weather_service.id}"
  desired_count = 1

  iam_role = "${aws_iam_role.ecs_service.name}"
  depends_on = ["aws_iam_role.ecs_service"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.weather_service.id}"
    container_name = "weather"
    container_port = 5000
  }
}

resource "aws_ecs_service" "stock_service" {
  name = "stock_service"
  cluster = "${data.terraform_remote_state.ecs_cluster.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.stock_service.id}"
  desired_count = 1

  iam_role = "${aws_iam_role.ecs_service.name}"
  depends_on = ["aws_iam_role.ecs_service"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.stock_service.id}"
    container_name = "stock"
    container_port = 5000
  }
}

#Logs
resource "aws_cloudwatch_log_group" "console_app" {
  name = "/ecs/console_app"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_group" "weather_service" {
  name = "/ecs/weather_service"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_group" "stock_service" {
  name = "/ecs/stock_service"
  retention_in_days = 7
}

#ALB non-default target groups/rules
resource "aws_alb_target_group" "weather_service" {
  name = "weather-service"
  port = 80
  protocol = "HTTP"
  vpc_id = "${data.terraform_remote_state.base.vpc_id}"
}
resource "aws_alb_target_group" "stock_service" {
  name = "stock-service"
  port = 80
  protocol = "HTTP"
  vpc_id = "${data.terraform_remote_state.base.vpc_id}"
}

resource "aws_alb_listener_rule" "weather_service" {
	listener_arn = "${data.terraform_remote_state.alb.internal_alb_listener_http_id}"
	priority = 100
	action {
		type = "forward"
		target_group_arn = "${aws_alb_target_group.weather_service.id}"
	}
	condition {
		field = "path-pattern"
		values = ["/weather/*"]
	}
}
resource "aws_alb_listener_rule" "stock_service" {
	listener_arn = "${data.terraform_remote_state.alb.internal_alb_listener_http_id}"
	priority = 200
	action {
		type = "forward"
		target_group_arn = "${aws_alb_target_group.stock_service.id}"
	}
	condition {
		field = "path-pattern"
		values = ["/stock/*"]
	}
}
