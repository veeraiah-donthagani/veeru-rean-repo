import boto3
import json
import csv
from datetime import datetime

from botocore.exceptions import ClientError
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication

default_region = 'us-east-1'
outputS3BucketName = "soumya-ssm"
ouputS3KeyPrefix = "Timezone"
csvFilePath = "InstancesTimeZone.csv"

timestr = datetime.utcnow().strftime("%Y%m%d-%H%M%S")
export_file_name = 'Instances-TimeZone-report'+ timestr + '.csv'

s3Client = boto3.client('s3')
s3RSClient = boto3.resource('s3')
s3Bucket = s3RSClient.Bucket(outputS3BucketName)

s3ObjectsListResp = s3Client.list_objects(Bucket=outputS3BucketName,Prefix=ouputS3KeyPrefix)

def cleanUPS3Bucket():
    s3Bucket.objects.all().delete()

#Getting TimeZone without downloading the file onto machine
def getTimeZone(objKey):
    stdOutData = s3RSClient.Object(outputS3BucketName, objKey).get()['Body'].read().decode("utf-8").rstrip(' \n')
    return stdOutData[stdOutData.find("is ")+4 : len(stdOutData)].rstrip('\n')

#Writing Data to CSV file
def csv_writer(filePath, rows):
    with open(filePath, 'w') as f:
        header = list(set(rows[0].keys()))
        header.sort()
        writer = csv.DictWriter(f, header)
        writer.writeheader()
        writer.writerows(rows)
    return header

#Sending mail to destination addr with csv file as an attachment
def send_mail(message, fromAddr, destAddr):
    sesClient = boto3.client('ses',region_name=default_region)
    response = sesClient.send_raw_email(
        RawMessage={
            'Data':message,
            },
            Source = fromAddr,
            Destinations=[destAddr])

#Deleting all the objects
#cleanUPS3Bucket()

#Getting InstaceId and TimeZone
rows = []
for objPath in s3Bucket.objects.all():
    column = {}  #Declaring empty dictonary to store values
    instanceID = str(objPath).split('/')[2]
    timeZone = getTimeZone(objPath.key)
    column['InstanceID'] = instanceID
    column['TimeZone'] = timeZone
    rows.append(column)

header = csv_writer(csvFilePath, rows)
print("Completed writing the TimeZone report with %d rows" % len(rows))

BODY_TEXT = "Hello,\r\nPlease see the attached file for Instances timezones."
# The character encoding for the email.
CHARSET = "utf-8"
msg = MIMEMultipart()
msg['Subject'] = 'TimeZone Report'
msg['From'] = 'veeraiah.donthagani@reancloud.com'
msg['To'] = 'veeraiah.donthagani@reancloud.com'
msg_body = MIMEMultipart('alternative')
textpart = MIMEText(BODY_TEXT.encode(CHARSET), 'plain', CHARSET)
msg_body.attach(textpart)
msg.attach(msg_body)
# the attachment
part = MIMEApplication(open(csvFilePath, 'rb').read())
part.add_header('Content-Disposition', 'attachment', filename=export_file_name)
msg.attach(part)

try:

 send_mail(msg.as_string(),msg['From'],msg['To'])

# Display an error if something goes wrong.
except ClientError as e:
    print(e.response['Error']['Message'])
else:
    print("Email sent successfully")
