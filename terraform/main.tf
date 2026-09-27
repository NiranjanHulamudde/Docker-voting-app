data "aws_ami" "ubuntu" {
	most_recent = true
	filter = {
		ami	= ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
		name	= "name"
}
	owners = ["099720109477"]
}

resource "aws_security_group" "web-sg" {
	name = "docker-voting-sg"
	description = "security group assigned to instance"
	
	# ingress rules for incoming traffic
	ingress {
		from_port = 5000
		to_port = 5000
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
}
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
}

	# egress for outgoing traffic
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_instance"	"server" {
	ami = data.aws_ami.ubuntu.id
	instance_type = var.instance_type
	
	key_name = passkey
	
	vpc_security_group_ids = aws_security_group.web-sg.id
	
	user_data = <<-EOF
			#!/bin/bash
			# Installing the docker and starting
			sudo apt-get update -y
			sudo apt-get install -y docker.io
			sudo systemctl start docker
			sudo systemctl enable docker
			sudo usermod -aG docker ubuntu
		
			# Pulling the app from docker hub
			sudo docker pull niranjanhulamudde/frontend:latest
			sudo docker pull niranjanhulamudde/backend:latest
		
			# Running the container, mapping the host port to 5000 to container port 5000
			sudo docker run -d -p 5000:5000 --restart always --name docker-voting-app-backend niranjanhulamudde/backend:latest
			sudo docker run -d -p 5000:80 --restart always --name docker-voting-app-frontend niranjanhulamudde/frontend:latest
			EOF

tags = {
	Name = "docker-voting-app"
}
}
	

	
