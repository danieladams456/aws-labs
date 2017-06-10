#!/usr/bin/env python
import os
import boto3
from boto3.dynamodb.conditions import Key
import json
import jmespath

#constants
TODO_LIST_TABLE_NAME = os.environ['TODO_LIST_TABLE_NAME']
TODO_LIST_INDEX_NAME = os.environ['TODO_LIST_INDEX_NAME']

#initialization
dynamodb = boto3.resource('dynamodb')
todoLists = dynamodb.Table(TODO_LIST_TABLE_NAME)

def get_lists_by_user(username):
    #print('getting todo lists for user ' + username)
    queryResult = todoLists.query(
        IndexName = TODO_LIST_INDEX_NAME,
        KeyConditionExpression = Key('username').eq(username)
    )
    assert queryResult['ResponseMetadata']['HTTPStatusCode'] == 200, 'Dynamo didn\'t return HTTP 200'
    return jmespath.search('Items[*].listname', queryResult)


def lambda_handler(event, context):
    #print(json.dumps(event))
    username = event['username']
    lists = get_lists_by_user(username)
    print("returning lists for user " + username + ": " + json.dumps(lists))
    return {'lists': lists}

#test code
if __name__ == '__main__':
    lambda_handler({'username': 'dadams'}, None)
