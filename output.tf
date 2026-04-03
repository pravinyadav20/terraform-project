output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "private_ip" {
  value = aws_instance.my_ec2.private_ip
}

output "instance_id" {
  value = aws_instance.my_ec2.id
}

output "security_group_id" {
  value = aws_security_group.allow_tls.id
}





