data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

# Security group configuration
resource "aws_security_group" "web_sg" {
  name        = "${var.server_name}-sg"
  description = "security group"

  # Inbound rules
  ingress {
    description = "Allow ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Ingress for application traffic
  ingress {
    description = "Allow traffic to the app"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Egress for all outgoing traffic
  egress {
    description = "Allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.ubuntu.id 
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id] 

  key_name = "awskey"

  tags = {
    Name = var.server_name 
}
}

