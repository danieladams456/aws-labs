import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

lambdaClient = boto3.client('lambda')

def get_lists(event):
    username = event['currentIntent']['slots']['username']
    payload = {'username': username}

    invoke_result = lambdaClient.invoke(FunctionName='todoListSample_getListsByUser',Payload=json.dumps(payload))
    assert invoke_result['ResponseMetadata']['HTTPStatusCode'] == 200, 'Dynamo didn\'t return HTTP 200'
    lambda_result = invoke_result['Payload'].read()
    print(lambda_result)


# Router to pick which method to invoke
def dispatch(event):
    intent_name = event['currentIntent']['name']

    # Dispatch to your bot's intent handlers
    if intent_name == 'GetLists':
        return get_lists(event)

    raise Exception('Intent with name ' + intent_name + ' not supported')


# Main handler
def lambda_handler(event, context):
    print(json.dumps(event))
    return dispatch(event)
