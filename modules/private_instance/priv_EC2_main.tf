# #create instance in private_subnet
# resource "aws_instance" "private_instance" {
#   ami           = var.image_id
#   instance_type = var.instance_type
#   subnet_id = var.sub_id
#   associate_public_ip_address = false
#   vpc_security_group_ids = [ var.instances_sg_id ]
#   key_name = "tobar"
#   tags = {
#     Name = var.instance_name
#   }  

#   # user_data = <<-EOF
#   #             #!/bin/bash
#   #             yum update -y
#   #             yum install -y httpd
#   #             systemctl start httpd
#   #             systemctl enable httpd
#   #             cat << 'EOT' > /var/www/html/index.html
#   #             ${templatefile("/home/ahmed/terraform_project/web_server/index.html", {
#   #               title = "Simple Web Page",
#   #               web_server = var.instance_name,
#   #             })}
#   #             EOT
#   #             EOF

#     provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "ec2-user" 
#       private_key = file(var.path_to_key_pair)
#       host        = self.private_ip

#       # Use the bastion host to connect to the private instance
#       bastion_host = var.bastion_host_public_ip  # Bastion instance public IP
#       bastion_user = "ec2-user"  # User for the bastion host
#       bastion_private_key = file(var.path_to_key_pair)  # SSH private key for bastion
#     }

#     inline = [
#       "sudo yum update -y",
#       "sudo yum install -y httpd",
#       "sudo systemctl start httpd",
#       "sudo systemctl enable httpd",
#       # Write the content of the HTML file to /var/www/html/index.html
#       #"echo '${local.html_content}' | sudo tee /var/www/html/index.html"
#     ]
#     }

#     # Use a file provisioner to upload the HTML file instead of echoing it
#     provisioner "file" {
#       source      = "/home/ahmed/terraform_project/web_server/index.html"  # Path to the local file
#       destination = "/tmp/index.html"  # Temporary location on the remote instance
#       connection {
#         type        = "ssh"
#         user        = "ec2-user"
#         private_key = file(var.path_to_key_pair)
#         host        = self.private_ip

#         bastion_host       = var.bastion_host_public_ip
#         bastion_user       = "ec2-user"
#         bastion_private_key = file(var.path_to_key_pair)
#       }
#     }

#     # Move the file from /tmp to the proper location and give it correct permissions
#     provisioner "remote-exec" {
#       connection {
#         type        = "ssh"
#         user        = "ec2-user"
#         private_key = file(var.path_to_key_pair)
#         host        = self.private_ip

#         bastion_host       = var.bastion_host_public_ip
#         bastion_user       = "ec2-user"
#         bastion_private_key = file(var.path_to_key_pair)
#       }

#       inline = [
#         "sudo mv /tmp/index.html /var/www/html/index.html",
#         "sudo chmod 644 /var/www/html/index.html"
#       ]
#     }

#   provisioner "local-exec" {
#     command = "echo Private IP of Web Server ${self.private_ip} >> ./IPs.txt"
#   }
# }

# # Define the content of index.html using templatefile()
# locals {
#   html_content = templatefile("/home/ahmed/terraform_project/web_server/index.html", {
#     title      = "Simple Web Page",
#     web_server = var.instance_name
#     })
#   }

locals {
  # Use templatefile() to replace placeholders with dynamic values for each instance
  html_content = templatefile("/home/ahmed/terraform_project/web_server/index.tpl", {
    title      = "Simple Web Page",
    web_server = var.instance_name  # This should be unique for each instance
  })
}

# Save the generated HTML content to a local file for each instance
resource "local_file" "generated_html" {
  content  = local.html_content
  filename = "/tmp/index_${var.instance_name}.html"  # Unique filename for each instance
}

# Create the EC2 instance in the private subnet
resource "aws_instance" "private_instance" {
  ami           = var.image_id
  instance_type = var.instance_type
  subnet_id     = var.sub_id
  associate_public_ip_address = false
  vpc_security_group_ids = [var.instances_sg_id]
  key_name      = "tobar"

  tags = {
    Name = var.instance_name  # Ensure that the instance name is unique
  }

  # Install necessary software (httpd)
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.path_to_key_pair)
      host        = self.private_ip
      bastion_host       = var.bastion_host_public_ip
      bastion_user       = "ec2-user"
      bastion_private_key = file(var.path_to_key_pair)
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

  # Upload the generated HTML file to the instance
  provisioner "file" {
    source      = "/tmp/index_${var.instance_name}.html"  # Upload unique HTML for each instance
    destination = "/tmp/index.html"  # Temporary location on the remote instance
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.path_to_key_pair)
      host        = self.private_ip
      bastion_host       = var.bastion_host_public_ip
      bastion_user       = "ec2-user"
      bastion_private_key = file(var.path_to_key_pair)
    }
  }

  # Move the file to the proper location and set permissions
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.path_to_key_pair)
      host        = self.private_ip
      bastion_host       = var.bastion_host_public_ip
      bastion_user       = "ec2-user"
      bastion_private_key = file(var.path_to_key_pair)
    }

    inline = [
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo chmod 644 /var/www/html/index.html"
    ]
  }

  # Output the private IP to a file
  provisioner "local-exec" {
    command = "echo Private IP of Web Server ${self.private_ip} >> ./IPs.txt"
  }
}
