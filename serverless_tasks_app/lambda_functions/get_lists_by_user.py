#!/usr/bin/env python
import boto3
from boto3.dynamodb.conditions import Key
import json
import jmespath

#constants
TODO_LIST_TABLE_NAME = 'todoListSample_TodoLists'

#initialization
dynamodb = boto3.resource('dynamodb')
todoLists = dynamodb.Table(TODO_LIST_TABLE_NAME)

def get_lists_by_user(username):
    #print('getting todo lists for user ' + username)
    queryResult = todoLists.query(
        IndexName = 'username-listname-index',
        KeyConditionExpression = Key('username').eq(username)
    )
    assert queryResult['ResponseMetadata']['HTTPStatusCode'] == 200, 'Dynamo didn\'t return HTTP 200'
    return jmespath.search('Items[*].listname', queryResult)


def lambda_handler(event, context):
    print(json.dumps(event))
    if 'username' in event:
        ret = get_lists_by_user(event['username'])
        print(ret)
        return ret
    else:
        return 'error'

#test code
if __name__ == '__main__':
    lambda_handler({'username': 'daniel'}, None)