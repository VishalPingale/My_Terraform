#instance-1

resource "aws_instance" "vm1" {
  ami                    = "ami-035827357e3c7e810"
  instance_type          = "t3.small"
  key_name               = "key-1"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.subnet-1.id
  tags = {
    Name = "Server-11"
  }

  user_data = <<-EOF
    #!/bin/bash
        yum install httpd -y
   echo "Hi I'm Instance-1" >/var/www/html/index.html
  systemctl enable httpd
  systemctl start httpd
EOF

}

resource "aws_security_group" "sg" {

  vpc_id = aws_vpc.vpc-1.id
  name   = "new_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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

#instance-2

resource "aws_instance" "vm2" {
  ami                    = "ami-035827357e3c7e810"
  instance_type          = "t3.small"
  key_name               = "key-1"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.subnet-2.id
  tags = {
    Name = "Server-22"
  }

  user_data = <<-EOF
    #!/bin/bash
        yum install httpd -y
   echo "Hi I'm Instance-2" >/var/www/html/index.html
  systemctl enable httpd
  systemctl start httpd
EOF

}

