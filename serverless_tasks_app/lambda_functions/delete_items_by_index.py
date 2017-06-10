#!/usr/bin/env python
import os
import boto3
import json

#constants
TODO_LIST_TABLE_NAME = os.environ['TODO_LIST_TABLE_NAME']

#initialization
dynamodb = boto3.resource('dynamodb')
todoLists = dynamodb.Table(TODO_LIST_TABLE_NAME)

#make sure it's an integer and between 0 and one million inclusive
def validate_is_integers(indexList):
    for index in indexList:
        assert type(index) == int and index >= 0 and index <= 1000000, 'Validation failed, indexes must be integers >= 0 and <= 1,000,000'

def delete_items_by_index(username, listname, indexList):
    keyMap = {'username': username, 'listname': listname}
    deleteItemsResult = todoLists.update_item(Key = keyMap)
    #generate update expression
    updateExpression = 'REMOVE '
    for index in indexList:
        updateExpression += 'listitems[' + str(index) + '],'
    #take off last comma
    updateExpression = updateExpression[:-1]
    # print(updateExpression)
    deleteItemsResult = todoLists.update_item(Key = keyMap,
                                              UpdateExpression = updateExpression,
                                              ReturnValues = 'ALL_NEW')

    assert deleteItemsResult['ResponseMetadata']['HTTPStatusCode'] == 200, 'Dynamo didn\'t return HTTP 200'
    return deleteItemsResult['Attributes']['listitems']


def lambda_handler(event, context):
    #print(json.dumps(event))
    username = event['username']
    listname = event['listname']
    indexes = event['indexes']
    deleteListResult = delete_items_by_index(username, listname, indexes)

    print('deleted items from ' + listname + ' for user ' + username + '.\nremaining items: ' + json.dumps(deleteListResult))
    return {'items': deleteListResult}

#test code
if __name__ == '__main__':
    lambda_handler({'username': 'dadams', 'listname': 'test', 'indexes': [0]}, None)
