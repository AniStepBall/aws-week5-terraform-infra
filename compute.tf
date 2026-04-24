resource "aws_instance" "web" {
    ami                         = "ami-004d320d42fde7f27"
    instance_type               = var.instance_type
    subnet_id                   = aws_subnet.public_a.id
    vpc_security_group_ids      = [aws_security_group.web_sg.id]
    associate_public_ip_address = true

    user_data = <<-EOF
        #!/bin/bash
        dnf update -y || yum update -y
        dnf install -y nginx || yum install -y nginx
        systemctl enable nginx
        echo "<h1>Week 5 Terraform EC2</h1>" > /usr/share/nginx/html/index.html
        systemctl start nginx
    EOF

    tags = {
        Name = "week5-web"
    }
}
