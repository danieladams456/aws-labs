resource "aws_dynamodb_table" "todoLists" {
  name = "todoListSample_TodoLists"
  read_capacity = 1
  write_capacity = 1

  hash_key = "username"
  range_key = "listname"

  attribute {
    name = "username"
    type = "S"
  }
  attribute {
    name = "listname"
    type = "S"
  }

  #create index for just getting the lists a user has saved
  local_secondary_index {
    name = "username-listname-index"
    range_key = "listname"
    projection_type = "KEYS_ONLY"
  }
}
#example queries
# aws dynamodb query --table-name todoListSample_TodoLists --index-name username-listname-index --key-condition-expression "username = :username" --expression-attribute-values '{":username":{"S":"daniel"}}'
# aws dynamodb put-item --table-name todoListSample_TodoLists --return-consumed-capacity INDEXES --item '{"username":{"S":"daniel"}, "listname":{"S":"thirdlist"}, "items":{"L": [{"S":"one"}, {"S":"two"}, {"S":"three"}]}}'
