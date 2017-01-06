#desination for the logs so they can be analyzed
resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name = "cloudtrail_logs"
  retention_in_days = 90
}

#event rule for email
resource "aws_cloudwatch_event_rule" "root_login" {
  name = "root_login_notification"
  description = "Send an email when root logs in."
  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS Console Sign In via CloudTrail"
  ],
  "detail": {
    "userIdentity": {
      "arn": [
        "arn:aws:iam::225730437332:root"
      ]
    }
  }
}
PATTERN
}

resource "aws_sns_topic" "root_login" {
  name = "root_login_notification"
}

resource "aws_cloudwatch_event_target" "root_login_sns" {
  rule = "${aws_cloudwatch_event_rule.root_login.name}"
  arn = "${aws_sns_topic.root_login.arn}"
  target_id = "root_login_sns"
  input = <<EOF
{"Message": "The root account has logged in."}
EOF
}
