data "archive_file" "get_lists_by_user" {
  type = "zip"
  source_file = "lambda_functions/get_lists_by_user.py"
  output_path = "lambda_functions/payloads/get_lists_by_user.zip"
}

resource "aws_lambda_function" "get_lists_by_user" {
  function_name = "todoListSample_getListsByUser"
  description = "Returns a list of the user's ToDo lists from DynamoDB"

  runtime = "python3.6"
  handler = "get_lists_by_user.lambda_handler"
  filename = "${data.archive_file.get_lists_by_user.output_path}"
  source_code_hash = "${data.archive_file.get_lists_by_user.output_base64sha256}"
  role = "${aws_iam_role.get_lists_by_user.arn}"
}
