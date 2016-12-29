#desination for the logs so they can be analyzed
resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name = "cloudtrail_logs"
}
