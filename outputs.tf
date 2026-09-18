output "instance_public_ip" {
	value	= aws_instance.server.public_ip
	description	= "The public ip of the newly built instance"
}

output "instance_arn" {
	value 	= aws_instance.server.arn
	description 	= "The Amazon resource name string for this server"
}

	

