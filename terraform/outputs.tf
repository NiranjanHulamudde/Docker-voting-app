output "instance_public_ip" {
	value = aws_instance.server.public_ip
	}
output "instance_arn" {
	value = aws_instance.server.arn
}
