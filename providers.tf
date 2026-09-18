terraform {
	required_version  = ">= 1.5.0"  #minimum version required of terraform
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~> 5.0"  # Protects against major updates
}
}
}

provider "aws" {
	region = var.aws_region  # Dynamic region as specified in the variable file
	}
