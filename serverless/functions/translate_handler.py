import os
import boto3
import json
import datetime

endpointUrl = os.environ['DYNAMODB_ENDPOINT']
translateHistoryTableName = os.environ['TRANSLATE_HISTORY_TABLE']

dynamodb_translate_history_tbl = boto3.resource('dynamodb', endpoint_url = endpointUrl).Table(translateHistoryTableName)

def translate(event, context):
    input_text = event['queryStringParameters']['input_text']

    translate = boto3.client('translate')
    response = translate.translate_text(
        Text=input_text,
        SourceLanguageCode='ja',
        TargetLanguageCode='en',
    )
    
    output_text = response.get('TranslatedText')

    dynamodb_translate_history_tbl.put_item(
        Item = {
            'timestamp': datetime.datetime.now().strftime("%Y%m%d%H%M%S"),
            'input_text': input_text,
            'output_text': output_text
        }
    )

    return {
        'statusCode': 200,
        'body': json.dumps({
            'output_text': output_text
        }),
        'isBase64Encoded': False,
        'headers': {}
    }
