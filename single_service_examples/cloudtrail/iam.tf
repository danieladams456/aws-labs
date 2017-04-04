resource "aws_iam_role" "cloudtrail_cloudwatchlogs" {
  name = "CloudTrail_CloudWatchLogs_Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudtrail_cloudwatchlogs" {
  name = "CloudTrail_CloudWatchLogs_Policy"
  role = "${aws_iam_role.cloudtrail_cloudwatchlogs.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "arn:aws:logs:us-east-1:225730437332:log-group:cloudtrail_logs:log-stream:*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:us-east-1:225730437332:log-group:cloudtrail_logs:log-stream:*"
      ]
    }
  ]
}
EOF
}
