#/////////////
# Terraform Version
#////////////////////
terraform {
  required_version = ">= 1.3.2"
}
# //////////
# PROVIDERS
# //////////
#
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
#
#Example of block Type
#block_type "block_label" "block_label"{
# 
#}
# Configuring the AWS provider in Terraform configuration file

provider "aws" {
  profile = "db-admin"
  region = "us-west-2"
}


#//////
#Data
#//////
data "aws_ssm_parameter" "latest_ami" {
 name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
# data "aws_ssm_parameter" "ubuntu-focal" {
#   name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
# }

# //////////
# RESOURCES
# ///////////
# resource "aws_key_pair" "instance_key_name" {
#   public_key = file(var.public_path)
#   key_name   = "lbitc-west-test-KP.pem"
# }

resource "aws_instance" "nodejs_amazn_instance" {
  count = 1
  ami = data.aws_ssm_parameter.latest_ami.value
  instance_type = "t2.micro"
  subnet_id = var.my-subnet-id
  associate_public_ip_address = "true"
  user_data = templatefile("${path.module}/userdata.sh",{
     aws_region = data.aws_region.current.name
     log_group_name = "${var.instance_name}-logs"
  })
  tags = {
  #  "Name" = "nodejs-ubu-${count.index}"
    "Name" = "${var.instance_name}-${count.index}"
    "Team" = "DevOps"}
  key_name = var.instance_key_name
    #vpc_security_group_ids = [ aws_security_group.lbitc_nodejs_sg.id ]
  vpc_security_group_ids = [
    aws_security_group.lbitc_nodejs_sg.id,
    module.mylbitc_mod.security_group_id
  ]
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
  } 
  iam_instance_profile = aws_iam_instance_profile.nodejs_instance_profile.name
}

module "mylbitc_mod" {
  source = "./modules/general_security"
  
}