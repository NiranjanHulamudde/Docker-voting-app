data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    name   = "name"
  }
  owners = ["099720109477"]
}

resource "aws_security_group" "web-sg" {
  name        = "docker-voting-sg"
  description = "security group assigned to instance"
  
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Added port 80 rule for the frontend web access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = "passkey"
  
 
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  
  
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
            
              # Pulling the application images
              sudo docker pull niranjanhulamudde/docker-voting-app-frontend:latest
              sudo docker pull niranjanhulamudde/docker-voting-app-backend:latest
            
              # FIXED: Backend running on host port 5000, Frontend running on host port 80
              sudo docker run -d -p 5000:5000 --restart always --name docker-voting-app-backend niranjanhulamudde/docker-voting-app-backend:latest
              sudo docker run -d -p 80:80 --restart always --name docker-voting-app-frontend niranjanhulamudde/docker-voting-app-frontend:latest
              EOF

  tags = {
    Name = "docker-voting-app"
  }
}
