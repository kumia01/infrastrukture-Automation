provider "aws" {
  region = "us-west-2"
  access_key = "XXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXX"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "example" {
  key_name = "example"
  public_key = "XXXXXXXXXXXXXXXX"
}

resource "aws_instance" "ansible_tower" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id = aws_subnet.example.id
  key_name = aws_key_pair.example.key_name

  provisioner "remote-exec" {
    inline = [
      "yum install -y ansible-tower-setup",
      "echo 'XXXXXXXXXXXXXXXX' | /usr/bin/tower-setup --license"
    ]
  }

  tags = {
    Name = "Ansible Tower"
  }
}

resource "aws_instance" "redhat_linux_1" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id = aws_subnet.example.id
  key_name = aws_key_pair.example.key_name

  tags = {
    Name = "Red Hat Linux 1"
  }
}

resource "aws_instance" "redhat_linux_2" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id = aws_subnet.example.id