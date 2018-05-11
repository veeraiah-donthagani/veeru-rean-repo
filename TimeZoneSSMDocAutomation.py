import boto3
import json
import time

default_region = 'us-east-1'
outputS3BucketName = "soumya-ssm"
ouputS3KeyPrefix = "Timezone"

s3Client = boto3.client('s3')
ec2Client = boto3.client('ec2')
ssmClient = boto3.client('ssm')
iamClient = boto3.client('iam')
s3RSClient = boto3.resource('s3')

s3Bucket = s3RSClient.Bucket(outputS3BucketName)
allinstance = ec2Client.describe_instances()


def ssm_command_run(InstanceId, ssmDoc):
    send_ssm = ssmClient.send_command(
                       InstanceIds = [InstanceId],
                       DocumentName = ssmDoc,
                       OutputS3BucketName = outputS3BucketName,
                       OutputS3KeyPrefix = ouputS3KeyPrefix
                       )

def cleanUPS3Bucket():
    s3Bucket.objects.all().delete()

#Deleting all the objects
cleanUPS3Bucket()

for i in allinstance['Reservations']:
    #print (allinstance)
    for j in i['Instances']:
        try:
            if j['IamInstanceProfile'] is not None:
                instprofile = j['IamInstanceProfile']['Arn'].split('/')
                x = instprofile[1]
                m = iamClient.get_instance_profile(InstanceProfileName=x)
                profilename = m['InstanceProfile']
                rolename = profilename['Roles'][0]['RoleName']
                ssm_test = \
                    iamClient.list_attached_role_policies(RoleName=rolename)
                isAttachedPolicesExistFlag = False
                #Checking for SSM policy name
                for policyName in ssm_test['AttachedPolicies']:
                    if policyName['PolicyName'].strip() in ['AmazonEC2RoleforSSM', 'AmazonSSMFullAccess']:
                        isAttachedPolicesExistFlag = True
                        break
                if isAttachedPolicesExistFlag:
                    #command_exec pass the command to get the command_id of below cat command, using that we will get the output of the command
                    instanceInfoResp = ssmClient.describe_instance_information(
                        Filters=[{'Key': 'InstanceIds','Values':[j['InstanceId']]}])
                    for instanceInfo in instanceInfoResp['InstanceInformationList']:
                        platformType = instanceInfo['PlatformType']

                    #Defining window, linux docs
                    linuxSSMDoc = "VerifyTimeZone-Linux"
                    windowsSSMDoc = "VerifyTimeZone-Windows"

                    if platformType == 'Windows':
                        ssm_command_run(j['InstanceId'], windowsSSMDoc)
                    elif platformType == 'Linux':
                        ssm_command_run(j['InstanceId'], linuxSSMDoc)

                else:
                    print (j['InstanceId'] + '-' + 'Instance without SSM')


        except:
            pass
