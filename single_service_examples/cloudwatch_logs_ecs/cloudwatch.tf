resource "aws_cloudwatch_log_group" "container-test" {
  name = "container-test"
  retention_in_days = 30
}
