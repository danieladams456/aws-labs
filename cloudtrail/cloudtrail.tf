resource "aws_cloudtrail" "dadamsio" {
  name = "dadamsio"
  s3_bucket_name = "${aws_s3_bucket.dadams-cloudtrail.id}"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_logs.id}"
  cloud_watch_logs_role_arn = "" #TODO need to define the role for this
}
