provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAS7JMASYXTDGE3IBM"
  secret_key = "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"
}

# 1. Create vpc

resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "production"
  }
}

# 2. Create Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}

# 3. Create custom route table

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }
  
  route {
      ipv6_cidr_block        = "::/0"
      gateway_id = aws_internet_gateway.gw.id 
    }

  tags = {
    Name = "Prod"
  }
}

# 4. Create a subnet 

variable "subnet_prefix" {
  description = "cidr block for the subnet"
  #default = "10.0.66.0/24"
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = var.subnet_prefix[0]
  availability_zone = "us-east-1a"

  tags = {
    Name = "Prod-subnet"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = var.subnet_prefix[1]
  availability_zone = "us-east-1a"

  tags = {
    Name = "Dev-subnet"
  }
}
# 5. Associate subnet with route table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}
# 6. Create security group to allow port 22, 80, 443

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
  }
  
  ingress {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
  }

  ingress {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
  }
  
  egress {
      description      = "HTTP, HTTPS, SSH"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
  }

  tags = {
    Name = "allow_web"
  }
}
# 7. Create a network interface with an IP in the subnet that was created in step 4

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}
# 8. Assign an elastic IP to the network interface created in step 4

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]
}
output "server_public_ip" {
  value = aws_eip.one.public_ip
}
# 9. Create Ubuntu server and install/enable apache2

resource "aws_instance" "web-server-instance" {
  # us-west-2
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "main-key"

  network_interface {
    network_interface_id = aws_network_interface.web-server-nic.id
    device_index         = 0
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your very first web server' > /var/www/html/index.html
              EOF    
    tags = {
        Name = "web-server"
    }         
}
