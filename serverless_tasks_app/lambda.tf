resource "aws_lambda_function" "get_lists_by_user" {
  function_name = "todoListSample_getListsByUser"
  description = "Returns a list of the user's ToDo lists from DynamoDB"

  runtime = "python2.7"
  handler = "get_lists_by_user.lambda_handler"
  filename = "${data.archive_file.get_lists_by_user.output_path}"
  source_code_hash = "${data.archive_file.get_lists_by_user.output_base64sha256}"
  role = "${aws_iam_role.lambda_dynamo.arn}"
  environment {
    variables {
      TODO_LIST_TABLE_NAME = "todoListSample_TodoLists"
      TODO_LIST_INDEX_NAME = "username-listname-index"
    }
  }
}

resource "aws_lambda_function" "get_items_from_list" {
  function_name = "todoListSample_getItemsFromList"
  description = "Returns the items from a ToDo list stored in DynamoDB"

  runtime = "python2.7"
  handler = "get_items_from_list.lambda_handler"
  filename = "${data.archive_file.get_items_from_list.output_path}"
  source_code_hash = "${data.archive_file.get_items_from_list.output_base64sha256}"
  role = "${aws_iam_role.lambda_dynamo.arn}"
  environment {
    variables {
      TODO_LIST_TABLE_NAME = "todoListSample_TodoLists"
    }
  }
}

data "archive_file" "get_lists_by_user" {
  type = "zip"
  source_file = "lambda_functions/get_lists_by_user.py"
  output_path = "lambda_functions/payloads/get_lists_by_user.zip"
}
data "archive_file" "get_items_from_list" {
  type = "zip"
  source_file = "lambda_functions/get_items_from_list.py"
  output_path = "lambda_functions/payloads/get_items_from_list.zip"
}
