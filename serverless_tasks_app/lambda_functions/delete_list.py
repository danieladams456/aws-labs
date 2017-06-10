#!/usr/bin/env python
import os
import boto3
import json

#constants
TODO_LIST_TABLE_NAME = os.environ['TODO_LIST_TABLE_NAME']

#initialization
dynamodb = boto3.resource('dynamodb')
todoLists = dynamodb.Table(TODO_LIST_TABLE_NAME)

def delete_list(username, listname):
    # print('getting todo list ' + listname + ' for user ' + username)
    keyMap = {'username': username, 'listname': listname}
    deleteListResult = todoLists.delete_item(Key = keyMap)

    assert deleteListResult['ResponseMetadata']['HTTPStatusCode'] == 200, 'Dynamo didn\'t return HTTP 200'
    return 'success'


def lambda_handler(event, context):
    #print(json.dumps(event))
    username = event['username']
    listname = event['listname']
    deleteListResult = delete_list(username, listname)

    print('deleted ' + listname + ' for user ' + username + ': ' + deleteListResult)
    return {'status': deleteListResult}

#test code
if __name__ == '__main__':
    lambda_handler({'username': 'dadams', 'listname': 'test'}, None)
