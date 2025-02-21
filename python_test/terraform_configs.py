from python_terraform import Terraform
import os
import json
import boto3

def run_terraform_configuration():
    print("ENTER")
    terraform = Terraform(working_dir=os.path.dirname(__file__)) # so it will find the tf file
    print("BEFORE INIT")

    try:
        return_code, stdout, stderr = terraform.init()
        if (return_code!=0):
            raise Exception(f"Terraform Init Failed: {stderr}")
        
        print("BEFORE PLAN")

        return_code, stdout, stderr = terraform.plan()
        if (return_code!=0):
            raise Exception(f"Terraform Plan Failed: {stderr}")
        
        print("BEFORE APPLY")
        
        return_code, stdout, stderr = terraform.apply(capture_output=True, auto_approve=True)
        print("AFTER APPLY")
        if return_code != 0:
            raise Exception(f"Terraform Apply Failed: {stderr}")
       # terraform.destroy() ###############################################################
        return stdout
    except Exception as e:
        print(f"Error executing Terraform: {e}")
        exit(1)
        
def fetch_ec2_detailes():
    ec2_client = boto3.client("ec2")
    instance_id, public_ip = None, None  # Default values
    instances = ec2_client.describe_instances()["Reservations"]
    for res in instances:
        for instance in res["Instances"]:
            if instance["State"]["Name"] == "running":
                instance_id = instance["InstanceId"]
                public_ip = instance["PublicIpAddress"]
                break
    if instance_id:
        instance_state = "running"
    else:
        instance_state = "not found"
    return instance_id, public_ip,instance_state

def fetch_lbs_detailes():
    elb_client = boto3.client("elbv2")
    lbs = elb_client.describe_load_balancers()["LoadBalancers"]
    if lbs:
        lb_dns = lbs[0]["DNSName"]
    else:
        lb_dns = None
    return lb_dns

def fetch_aws_details():
    instance_id, public_ip,instance_state = fetch_ec2_detailes()
    lb_dns=fetch_lbs_detailes()

    validation_data = {
        "instance_id": instance_id,
        "instance_state": instance_state,
        "public_ip": public_ip,
        "load_balancer_dns": lb_dns
    }

    file=open("aws_validation.json", "w")
    json.dump(validation_data, file, indent=4)
    file.close()
    
def destroy_terra():
    try:
        return_code, stdout, stderr = terraform.destroy()
        if (return_code!=0):
            raise Exception(f"Terraform Init Failed: {stderr}")
    
    except Exception as e:
        print(f"Error executing Terraform destroy: {e}")
        exit(1)
    
    
