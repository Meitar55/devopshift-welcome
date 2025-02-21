from jinja_temp import terraform_from_python
from terraform_configs import run_terraform_configuration, fetch_aws_details, destroy_terra
import subprocess
import os

#user menu propmt
def get_user_inputs():
    amis = {
        "ubuntu": "ami-0dee1ac7107ae9f8c",
        "amazon-linux": "ami-0f1a6835595fb9246"
    }
    instance_types = {"small": "t3.small", "medium": "t3.medium"}

    ami_choice = input("Choose AMI (ubuntu/amazon-linux): ")
    instance_choice = input("Choose instance type (small/medium): ")
    region = input("Enter AWS region (Only us-east-1 allowed): ")
    lb_name = input("Enter Load Balancer name: ")

    if region != "us-east-1":
        print("Invalid region, the default is region us-east-1")
        region = "us-east-1"

    return {
        "ami": amis.get(ami_choice),#, "ami-12345678"),
        "instance_type": instance_types.get(instance_choice),#, "t3.small"),
        "region": region,
        "load_balancer_name": lb_name,
        "availability_zone": "us-east-1a"
    }
    

def main():
    # Get the current directory (where main.py is)
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Path to the requirements.txt file
    requirements_file = os.path.join(current_dir, "requierments.txt")
    
    # Check if the requirements.txt file exists
    if not os.path.isfile(requirements_file):
        print(f"Error: '{requirements_file}' not found.")
    else:
        try:
            # Run the pip install command
            subprocess.run(["pip", "install", "-r", requirements_file], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error during installation: {e}")
            exit(1)
    print("""
          
          
          
-----------------------------------------
          """)
      
    #task starts here  
    user_inputs=get_user_inputs()
    terraform_from_python(user_inputs)
    
    run_terraform_configuration()
    fetch_aws_details()

    destroy_terra()

if __name__ == "__main__":
    main()