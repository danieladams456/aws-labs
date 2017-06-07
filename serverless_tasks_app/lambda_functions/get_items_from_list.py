#!/usr/bin/env python
import os
import boto3
import json

#constants
TODO_LIST_TABLE_NAME = os.environ['TODO_LIST_TABLE_NAME']

#initialization
dynamodb = boto3.resource('dynamodb')
todoLists = dynamodb.Table(TODO_LIST_TABLE_NAME)

def get_items_from_list(username, listname):
    # print('getting todo list ' + listname + ' for user ' + username)
    keyMap = {'username': username, 'listname': listname}
    getItemResult = todoLists.get_item(Key = keyMap)

    assert getItemResult['ResponseMetadata']['HTTPStatusCode'] == 200, 'Dynamo didn\'t return HTTP 200'
    if 'Item' in getItemResult and 'listitems' in getItemResult['Item']:
        return getItemResult['Item']['listitems']
    else:
        return []


def lambda_handler(event, context):
    #print(json.dumps(event))
    username = event['params']['path']['username']
    listname = event['params']['path']['listname']
    items = get_items_from_list(username, listname)

    print('returning items for user ' + username + ' in list ' + listname + ': '+ json.dumps(items))
    return {'items': items}

#test code
if __name__ == '__main__':
    lambda_handler({'params': {'path': {'username': 'dadams', 'listname': 'test'}}}, None)
