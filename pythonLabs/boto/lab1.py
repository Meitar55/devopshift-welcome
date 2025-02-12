import logging
import boto3
import boto3.exceptions
from botocore.exceptions import ClientError

def create_bucket(bucket_name, region=None):
    # Create bucket
    try:
        if region is None:
            s3_client = boto3.client('s3')
            s3_client.create_bucket(Bucket=bucket_name)
        else:
            s3_client = boto3.client('s3', region_name=region)
            location = {'LocationConstraint': region}
            s3_client.create_bucket(Bucket=bucket_name,
                                    CreateBucketConfiguration=location)
        print('your bucket ',bucket_name,' was created. if you wish to see it, choose "list buckets" next, in main menu')
    except botocore.
    except ClientError as e:
        #logging.error(e)
        print(e.with_traceback)
        
        
def delete_bucket(client, bucket):
    response = client.delete_bucket(
                Bucket=bucket,
            )
    print('your bucket ',bucket,' was deleted. if you wish to check it, choose "list buckets" next, in the menu')

def manage_S3_buckets():
    while True:
        print("please choose :")
        print("""1-list Buckets
        2 - create  bucket
        3 - delete  bucket
        4 - exit
                """)
        uc=input("please enter your choice: ")
        try:
            s3_client=boto3.client("s3")
            if uc=="1":
                response=s3_client.list_buckets()
                # Output the bucket names
                print('Existing buckets:')
                for bucket in response['Buckets']:
                    print(f'  {bucket["Name"]}')
                print("/n/n")
            elif uc=="2":
                name=input("please insert a bucket name: ")
                create_bucket(name) 
            elif uc=="3":
                name=input("please insert a bucket name for deletion: ")
                delete_bucket(s3_client,name)
            else: break
        except Exception as e:
            print("exception happened")
            print(e)



print("please choose :")
print("""1-Manage S3 Buckets
2 - Manage EC2 Instances
any othe key - Exit
         """)
uc=input("please enter your choice: ")
if(uc == "1"): 
    manage_S3_buckets()
elif(uc=="2"):
    pass
else: 
    exit(0)

