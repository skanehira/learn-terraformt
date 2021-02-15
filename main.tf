provider aws {
  region = "ap-northeast-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "example_ec2" {
  name = "example-ec2"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami = "ami-0467c3f85975d8a26"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.example_ec2.id]

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
}

output "example" {
  value = aws_instance.example.public_dns
}
