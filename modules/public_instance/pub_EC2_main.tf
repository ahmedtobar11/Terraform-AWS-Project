#create instance in public_subnet
resource "aws_instance" "public_instance" {
  ami           = var.image_id
  instance_type = var.instance_type
  subnet_id = var.sub_id
  associate_public_ip_address = true
  vpc_security_group_ids = [ var.instances_sg_id ]
  key_name = "tobar"

  # user_data = <<-EOF
  #   #!/bin/bash

  #   # Update system packages
  #   sudo yum update -y

  #   # Install Nginx
  #   sudo yum install nginx -y

  #   # Configure Nginx as a proxy
  #   sudo tee /etc/nginx/conf.d/proxy.conf > /dev/null <<EOFC
  #   server {
  #       listen 80;
  #       server_name your_domain.com;

  #       location / {
  #           proxy_pass http://${var.alb_dns_name};
  #           proxy_set_header Host \$host;
  #           proxy_set_header X-Real-IP \$remote_addr;
  #       }
  #   }
  #   EOFC

  #   # Restart Nginx
  #   sudo service nginx restart
  # EOF

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"            
      private_key = file(var.path_to_key_pair)
      host        = self.public_ip    
    }

    inline = [
      # Update system packages
      "sudo yum update -y",

      # Install Nginx
      "sudo yum install nginx -y",

      # Create Nginx proxy configuration
      "sudo tee /etc/nginx/conf.d/proxy.conf > /dev/null <<EOF",
      "server {",
      "    listen 80;",
      "    server_name your_domain.com;",  # Replace with your actual domain or use Terraform variable
      "    location / {",
      "        proxy_pass http://${var.alb_dns_name};",
      "        proxy_set_header Host \\$host;",
      "        proxy_set_header X-Real-IP \\$remote_addr;",
      "    }",
      "}",
      "EOF",

      # Restart Nginx to apply the configuration
      "sudo service nginx restart"
    ]
  }


  tags = {
    Name = var.instance_name
  }
  provisioner "local-exec" {
    command = "echo Private IP of Proxy Server ${self.private_ip} >> ./IPs.txt"
  }
}
