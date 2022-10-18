#output "name" {
#  value = "values"
#}
output "instance_dns" {
  value = aws_instance.nodejs_ubu_instance[*].public_dns
}

output "instance_id" {
  value = aws_instance.nodejs_ubu_instance[*].id
}

output "instance_ip" {
  value = aws_instance.nodejs_ubu_instance[*].public_ip
}

output "security_group_id" {
    value = aws_security_group.lbitc_nodejs_sg.id
}