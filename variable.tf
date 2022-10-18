variable "instance_key_name" {
    description = "Name of our APP VPC KeyPair"
    type = string
}

variable "instance_name" {
    description = "Name Tag of Our EC2 Instance"
    type = string
}

variable "instance_allow_ssh" {
   description = "Whether or not  to allow ssh"
   type = bool
   default = false

}

variable "environment" {
   description = "Name of the environment to change"
   type = string
}

variable "my-vpc-id" {
   description = "Private VPC ID"
   type = string
}

variable "my-subnet-id" {
   description = "My primary custome public subnet"
   type = string
}

variable "public_path" {
    default  = "./secret/key/lbitc-west-test-KP.pem"
}