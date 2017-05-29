#Roles for lambda functions
resource "aws_iam_role" "get_lists_by_user" {
  name = "todoListSample_getListsByUser"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow"
  }
]
}
EOF
}

#lambda still isn't logging
resource "aws_iam_role_policy" "get_lists_by_user" {
  name = "dynamodb_query_todo_lists"
  role = "${aws_iam_role.get_lists_by_user.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "dynamodb:Query",
      "Resource": "arn:aws:dynamodb:us-east-1:225730437332:table/todoListSample_TodoLists/index/username-listname-index"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}
