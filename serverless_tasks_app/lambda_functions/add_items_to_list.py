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
def add_items_to_list(username, listname, items):
    keyMap = {'username': username, 'listname': listname}
    updateExpression = 'SET listitems = list_append(if_not_exists(listitems, :empty_list), :newItems)'
    expressionAttributeValues = {':newItems': items, ':empty_list': []}
    addItemsResult = todoLists.update_item(Key = keyMap,
                                           UpdateExpression = updateExpression,
                                           ExpressionAttributeValues = expressionAttributeValues,
                                           ReturnValues = 'ALL_NEW')

    assert addItemsResult['ResponseMetadata']['HTTPStatusCode'] == 200, 'Dynamo didn\'t return HTTP 200'
    return addItemsResult['Attributes']['listitems']


def lambda_handler(event, context):
    #print(json.dumps(event))
    username = event['params']['path']['username']
    listname = event['params']['path']['listname']
    items = event['body-json']['items']
    addItemsResult = add_items_to_list(username, listname, items)

    print('added ' + json.dumps(items) + ' to list ' + listname + ' for user ' + username)
    return {'items': addItemsResult}

#test code
if __name__ == '__main__':
    lambda_handler({'params': {'path': {'username': 'dadams', 'listname': 'test'}, 'body-json': {'items': ['eight', 'seven']}}}, None)
