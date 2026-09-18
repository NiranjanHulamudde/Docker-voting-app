variable "aws_region" {
	type 	= string
	description	= "The target aws region for deployment"
	default 	= "us-east-1"
}

variable "instance_type" {
	description	= "The size of the virtual machine"
	default		= "t3.micro"
}

variable  "server_name" {
	type	= string 
	description	= "Value for the  name tag of the istance"
	default		=  "my_terraform_app"
}

