# AWS Infrastructure with Terraform
### * `main.tf` root terraform file and the root `outputs.tf` terraform file are in directory "terraform test"
## Architecture

- VPC with configurable CIDR block
- Public and private subnets across different availability zones
- Internet Gateway for public subnet access
- EC2 instances in the public subnets
- Application Load Balancer with autoscaling


## Modules
### * All modules files, according to tests' tasks are in directory "terraform test/modules"

### Network Module
- Creates VPC infrastructure
- Configurable public and private subnets
- Associates routing tables and internet gateway

### EC2 Module
- Deploys EC2 instances in public subnets
- Configurable instance type and AMI through variables
- Security group with HTTP and SSH access

### ALB Module
- Application Load Balancer with HTTP listener
- Autoscaling group with configurable min/max instances
- Health checks and target group configuration

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Configuration Variables

### Network Module
- `region`: AWS region (default: us-east-1)
- `cidrBlockRange`: VPC CIDR block size (default: 16)
- `countPublicSubnets`: Number of public subnets (default: 2)
- `countPrivateSubnets`: Number of private subnets (default: 1)

### EC2 Module
- `instance_type`: EC2 instance size (default: t2.micro)
- `assignPublicIP`: Toggle public IP assignment (default: true)

### ALB Module
- `instance_type`: Instance type for ASG (default: t2.micro)
- `min_size`: Minimum number of instances (default: 1)
- `max_size`: Maximum number of instances (default: 3)



## Security

- ALB security group allows inbound HTTP (port 80)
- EC2 instances allow inbound HTTP from ALB only
- Public instances allow SSH access (port 22)
- All outbound traffic is allowed

## Outputs

- VPC details via `vpc_output`
- EC2 instance details via `ec2_output`
- ALB DNS name via `dns_output`

# Open Terraform Questions Answers
### In file `terraform solutions.pdf` (includes task 5 from hands-on section)
# Multi Choice And Open AWS Questions Answers
### In file `AWS solutions.pdf`
### * Both PDF files are in directory "terraform test/Answers"
