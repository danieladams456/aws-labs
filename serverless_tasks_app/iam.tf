#Roles for lambda functions
resource "aws_iam_role" "lambda_dynamo" {
  name = "todoListSample_lambdaDynamo"
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

resource "aws_iam_role_policy" "get_lists_by_user" {
  name = "dynamodb_query_todo_lists"
  role = "${aws_iam_role.lambda_dynamo.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:Query",
        "dynamodb:GetItem"
      ],
      "Resource": [
        "arn:aws:dynamodb:us-east-1:225730437332:table/todoListSample_TodoLists",
        "arn:aws:dynamodb:us-east-1:225730437332:table/todoListSample_TodoLists*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:us-east-1:225730437332:/aws/lambda*"
    }
  ]
}
EOF
}
