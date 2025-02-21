# Python Exam

## Overview
This project automates the deployment of an AWS EC2 instance attached to an Application Load Balancer (ALB) using Terraform, Python, and Boto3. The infrastructure is dynamically generated using Jinja2 templates, executed via Terraform, and validated using AWS APIs.

## Features
- *Dynamic Terraform Configuration*: Uses Jinja2 templating to generate Terraform scripts.
- *Automated Deployment*: Terraform execution is managed through Python.
- *AWS Resource Validation*: Uses Boto3 to confirm EC2 instance and ALB deployment.
- *Error Handling & Modularization*: Functions and classes are well-structured with exception handling.
- *Infrastructure Cleanup*: Ability to destroy Terraform-managed resources when no longer needed.

## Prerequisites
Ensure you have the following installed:
- Python 3.x
- Terraform
- AWS CLI (configured with credentials)
---> AWS Credentials
Please ensure that your AWS credentials are configured properly using the AWS CLI. The script will rely on the following AWS environment variables:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
and will install all requiered dependencies.

## Usage
### Step 1: Configure AWS Credentials
Ensure AWS credentials are set up using the AWS CLI:
sh
aws configure


### Step 2: Run the Script
Execute the main script to start the deployment:
sh
python main.py

You will be prompted to enter:
- AMI selection (Ubuntu or Amazon Linux)
- Instance type (t3.small/t3.medium)
- Load Balancer name

### Step 3: Validate Deployment
After successful execution, the script generates aws_validation.json with details of the deployed resources:
json
{
    "instance_id": "i-0123456789abcdef0",
    "instance_state": "running",
    "public_ip": "3.92.102.45",
    "load_balancer_dns": "my-alb-123456.elb.amazonaws.com"
}


### Step 4: Destroy Infrastructure
at the end of running the code, it will terminate all resources using
terraform destroy



### File Descriptions:
- **`main.py`**: The core script that automates the provisioning of AWS resources using Terraform. It includes a user prompt for input and processes the Terraform configuration.
- **`mock_fetch.py`**: A mock script that generates a JSON file (`aws_validation.json`) with simulated AWS details (for testing purposes).
- **`terraform_configs.py`**: Contains various functions that interact with Terraform and AWS services, including the logic to provision resources and fetch AWS details (EC2, Load Balancers).
- **`jinja_temp.py`**: Manages the Jinja2 template rendering for creating Terraform configuration files dynamically based on user input.
- **`requirements.txt`**: Lists all Python dependencies required for the project (like `boto3`, `terraform`, etc.).
- **`aws_validation.json`**: A mock JSON file that will be created after running the `mock_fetch.py` script. It contains simulated AWS resource details.
- **`README.md`**: The documentation for the project, explaining how to use and contribute to it.




## Error Handling
- Handles invalid AWS regions, Terraform execution failures, and AWS API errors.
- Uses try-except blocks for better reliability.
