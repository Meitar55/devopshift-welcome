# mock_fetch.py

# Import the required functions
from terraform_configs import fetch_aws_details
from unittest.mock import patch

# Mock the EC2 client function
def mock_ec2_client():
    return {
        "Reservations": [
            {
                "Instances": [
                    {
                        "InstanceId": "i-0a1b2c3d4e5f6g7h8",
                        "State": {"Name": "running"},
                        "PublicIpAddress": "54.123.45.67"  # Ensure this key is present for the "running" instance
                    },
                    {
                        "InstanceId": "i-0a1b2c3d4e5f6g7h9",
                        "State": {"Name": "stopped"},
                        # No PublicIpAddress here to simulate a stopped instance (no public IP)
                    }
                ]
            }
        ]
    }

# Mock the ELB client function
def mock_elb_client():
    return {
        "LoadBalancers": [
            {
                "DNSName": "my-load-balancer-12345678.us-east-1.elb.amazonaws.com"
            }
        ]
    }

# Override fetch_ec2_detailes to return mock data
def mock_fetch_ec2_detailes():
    ec2_client = mock_ec2_client()
    instance_id = None
    public_ip = None
    instances = ec2_client["Reservations"]
    
    for res in instances:
        for instance in res["Instances"]:
            if instance["State"]["Name"] == "running":
                instance_id = instance["InstanceId"]
                public_ip = instance.get("PublicIpAddress", "N/A")  # .get() safely retrieves the value or returns "N/A"
                break
    
    if instance_id:
        instance_state = "running"
    else:
        instance_state = "not found"
    
    return instance_id, public_ip, instance_state

# Override fetch_lbs_detailes to return mock data
def mock_fetch_lbs_detailes():
    elb_client = mock_elb_client()
    lbs = elb_client["LoadBalancers"]
    
    if lbs:
        lb_dns = lbs[0]["DNSName"]
    else:
        lb_dns = None
    
    return lb_dns



# Use unittest.mock.patch to replace the actual functions with the mocks
with patch('terraform_configs.fetch_ec2_detailes', mock_fetch_ec2_detailes), \
        patch('terraform_configs.fetch_lbs_detailes', mock_fetch_lbs_detailes):
    fetch_aws_details()  # Call the function to generate the mock file
