output "instance_id" {
    value = aws_instance.public_instance.id
}

output "public_ip" {
    value = aws_instance.public_instance.public_ip
}

