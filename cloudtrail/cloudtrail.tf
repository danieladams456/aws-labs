resource "aws_cloudtrail" "dadamsio" {
  name = "dadamsio"
  s3_bucket_name = "${aws_s3_bucket.dadams-cloudtrail.id}"
  is_multi_region_trail = false

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}"
  cloud_watch_logs_role_arn = "${aws_iam_role.cloudtrail_cloudwatchlogs.arn}"
}
