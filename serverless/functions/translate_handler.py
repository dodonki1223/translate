import json
import boto3

def translate(event, context):
    input_text = event['queryStringParameters']['input_text']

    translate = boto3.client('translate')
    response = translate.translate_text(
        Text=input_text,
        SourceLanguageCode='ja',
        TargetLanguageCode='en',
    )
    
    output_text = response.get('TranslatedText')

    return {
        'statusCode': 200,
        'body': json.dumps({
            'output_text': output_text
        }),
        'isBase64Encoded': False,
        'headers': {}
    }
