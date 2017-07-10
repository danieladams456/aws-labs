import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

lambdaClient = boto3.client('lambda')

def get_lists(event):
    username = event['userId']
    payload = {'username': username}

    invoke_result = lambdaClient.invoke(FunctionName='todoListSample_getListsByUser',Payload=json.dumps(payload))
    assert invoke_result['ResponseMetadata']['HTTPStatusCode'] == 200, 'Dynamo didn\'t return HTTP 200'
    lambda_result = json.loads(invoke_result['Payload'].read())
    logger.info(lambda_result)

    #generate response structure
    if 'lists' in lambda_result and len(lambda_result['lists']) > 0:
        response_message = "Your lists are: "
        for list_name in lambda_result['lists']:
            response_message += '\n' + list_name
    else:
        response_message = "Currently you have no lists."
    return close_fulfilled_generator(response_message)

def add_list(event):
    username = event['userId']
    list_name = event['currentIntent']['slots']['ListName']
    payload = {'username': username, 'listname': list_name}

    invoke_result = lambdaClient.invoke(FunctionName='todoListSample_putList',Payload=json.dumps(payload))
    assert invoke_result['ResponseMetadata']['HTTPStatusCode'] == 200, 'Dynamo didn\'t return HTTP 200'
    lambda_result = json.loads(invoke_result['Payload'].read())
    logger.info(lambda_result)

    #generate response structure
    if lambda_result['status'] == 'success':
        return close_fulfilled_generator('Successfully added list ' + list_name)
    else:
        return close_failed_generator('Failed adding list ' + list_name)


def close_fulfilled_generator(message):
    return {'dialogAction': {'type': 'Close', 'fulfillmentState': 'Fulfilled', 'message': {'contentType': 'PlainText', 'content': message}}}
def close_failed_generator(message):
    return {'dialogAction': {'type': 'Close', 'fulfillmentState': 'Failed', 'message': {'contentType': 'PlainText', 'content': message}}}

# Router to pick which method to invoke
def dispatch(event):
    intent_name = event['currentIntent']['name']

    # Dispatch to your bot's intent handlers
    if intent_name == 'GetLists':
        return get_lists(event)
    elif intent_name == 'AddList':
        return add_list(event)

    return close_failed_generator('Intent with name ' + intent_name + ' not supported')


# Main handler
def lambda_handler(event, context):
    logger.info(json.dumps(event))
    return dispatch(event)
