# main.tf

# Configure the AWS provider
# This tells Terraform we want to manage resources in AWS
provider "aws" {
  region = "eu-north-1" # Make sure this matches the region in your AWS console (Stockholm)
}

# Define an AWS EC2 instance resource
resource "aws_instance" "web_server" {
  # ami-0c4636f1c246f903d is an example AMI for Amazon Linux 2 (HVM), SSD Volume Type
  # This AMI is typically available in eu-north-1.
  # You can search for AMIs in your AWS console -> EC2 -> AMIs, and filter for "Amazon Linux 2"
  ami           = "ami-0c4636f1c246f903d"
  instance_type = "t2.micro" # Free tier eligible instance type

  # Associate a security group to allow inbound traffic
  # We'll create this security group next
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Add tags to the instance for identification
  tags = {
    Name        = "MyTerraformWebServer"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# Define an AWS Security Group resource
# This acts as a firewall for our EC2 instance
resource "aws_security_group" "web_sg" {
  name        = "web-server-security-group"
  description = "Allow HTTP traffic"

  # Ingress (inbound) rules
  ingress {
    from_port   = 80          # Allow HTTP port
    to_port     = 80
    protocol    = "tcp"       # TCP protocol
    cidr_blocks = ["0.0.0.0/0"] # Allow from anywhere (for demonstration)
    description = "Allow inbound HTTP"
  }

  # Egress (outbound) rules - allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}

# Output the public IP address of the EC2 instance
# This will be shown in your terminal after 'terraform apply'
output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}



# commands that I would hit if I were to run this code and had AWS:
# 1. Initialize the Terraform configuration
#    terraform init
# 2. Validate the configuration
#    terraform validate
# 3. Plan the deployment to see what resources will be created
#    terraform plan
# 4. Apply the configuration to create the resources
#    terraform apply
# 5. To destroy the resources when done
#    terraform destroy