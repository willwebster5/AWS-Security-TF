import boto3
import json
import uuid

def lambda_handler(event, context):
    instance_id = event['detail']['resource']['instanceDetails']['instanceId']
    s3_bucket_name = "SSHBruteForceResponseAuthBucket-aeidkwxio3092df3"  # Replace with your actual S3 bucket name

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

    # Save logs to S3
    s3_client = boto3.client('s3')
    object_name = f"{instance_id}-{uuid.uuid4()}.log"
    s3_client.put_object(Bucket=s3_bucket_name, Key=object_name, Body=log_contents)

    return {
        'statusCode': 200,
        'body': json.dumps(f'Command executed and logs saved to S3 bucket {s3_bucket_name} with object name {object_name}.')
    }
