#!/usr/bin/env python
import os
import boto3
import json

#constants
TODO_LIST_TABLE_NAME = os.environ['TODO_LIST_TABLE_NAME']

#initialization
dynamodb = boto3.resource('dynamodb')
todoLists = dynamodb.Table(TODO_LIST_TABLE_NAME)

#items should be a list to append to the existing list in DynamoDB
def put_list(username, listname, items):
    keyMap = {'username': username, 'listname': listname, 'listitems': items}
    addListResult = todoLists.put_item(Item=keyMap)

    assert addListResult['ResponseMetadata']['HTTPStatusCode'] == 200, 'Dynamo didn\'t return HTTP 200'
    print(addListResult)
    return 'success'


def lambda_handler(event, context):
    print(json.dumps(event))
    username = event['params']['path']['username']
    listname = event['params']['path']['listname']
    items = event['body-json']['items']
    addListResult = put_list(username, listname, items)

    print('put list ' + ' for user ' + username + ' with items: ' + json.dumps(items))
    return {'status': addListResult}

#test code
if __name__ == '__main__':
    lambda_handler({'params': {'path': {'username': 'dadams', 'listname': 'test'}, 'body-json': {'items': ['seven', 'six']}}}, None)
