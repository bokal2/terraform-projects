
resource "aws_security_group" "nginx-server-sg" {
  description = "Security group allowing HTTP(port 80) and HTTPS(port 443)"
  name        = "nginx-server-sg"
  vpc_id      = aws_vpc.project01-vpc.id

  # Allow inbound HTTP traffic on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTP traffic on port 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(local.common_tags, {
    Name = "nginx-server-sg"
  })

}

resource "aws_instance" "nginx-server" {
  ami                         = "ami-0866a3c8686eaeeba"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.nginx-server-sg.id]


  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt-get install -y nginx
                sudo systemctl start nginx
                sudo systemctl enable nginx
                EOF

  tags = merge(local.common_tags, {
    Name = "project01-nginx-server"
  })

  lifecycle {
    create_before_destroy = true
  }
}
