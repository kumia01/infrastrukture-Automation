terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.51.0"
    }
  }
}

# Provider configuration
provider "aws" {
  region = "eu-west-2" 

}

# EC2 instance resources
resource "aws_instance" "webserver" {
  ami           = "ami-0aaa5410833273cfe"
  instance_type = "t2.micro"
  count         = 2
  key_name = "redhat_test"
  subnet_id = "subnet-0c8329ddafc25d35b"
  vpc_security_group_ids = ["sg-016087d20d1d334f3"]
  associate_public_ip_address = true
  
  # Tags
  tags = {
    Name = "webserver-cluster-${count.index}"
  }

  # User data script to install NGINX
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

}

