import boto3
import json
import os
import requests

def get_secret():
    secret_name = "slack/webhook"
    region_name = "us-west-2"

    client = boto3.client('secretsmanager', region_name=region_name)

    response = client.get_secret_value(SecretId=secret_name)
    return json.loads(response['SecretString'])['webhook']

def lambda_handler(event, context):
    instance_id = event['detail']['resource']['instanceDetails']['instanceId']
    slack_webhook = get_secret()

    ssm_client = boto3.client('ssm')
    response = ssm_client.send_command(
        InstanceIds=[instance_id],
        DocumentName='AWS-RunShellScript',
        Parameters={
            'commands': ['cat /var/log/auth.log']
        }
    )

    command_id = response['Command']['CommandId']

    # Get Command Output (you may have to add delay or checks for command completion)
    output = ssm_client.get_command_invocation(
        InstanceId=instance_id,
        CommandId=command_id
    )

    log_contents = output['StandardOutputContent']

    # Send logs to Slack
    requests.post(slack_webhook, json={"text": f"SSH auth.log from {instance_id}:\n```\n{log_contents}\n```"})

    return {
        'statusCode': 200,
        'body': json.dumps('Command executed and logs sent to Slack.')
    }
