provider "aws" {
  region = "us-east-1"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# Get my IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_instance" "juice-shop" {
  ami = data.aws_ami.amazon-linux-2.id
  # ami = "ami-0b5eea76982371e91"
  instance_type = "t2.medium"
  tags = {
    "Name" = "juice-shop"
  }
  vpc_security_group_ids = ["${resource.aws_security_group.allow_http.id}"]
  user_data              = <<EOF
#!/bin/bash
yum update -y
yum install -y docker
service docker start
docker pull bkimminich/juice-shop
docker run -d -p 80:3000 bkimminich/juice-shop
EOF
}

output "ec2_global_ips" {
  value = ["${aws_instance.juice-shop.public_ip}"]
}
