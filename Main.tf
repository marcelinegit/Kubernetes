#creat vpc 
resource "aws_vpc" "minikube-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Project-vpc"
  }
}
resource "aws_default_route_table" "minikube-drt" {
  default_route_table_id = aws_vpc.minikube-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.minikube-gw.id
  }

  tags = {
    Name = "minikube-drt"
  }
}

resource "aws_subnet" "minikube-subnet1" {
  vpc_id     = aws_vpc.minikube-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Project-subnet1"
  }
}

resource "aws_subnet" "minikube-subnet2" {
  vpc_id     = aws_vpc.minikube-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Project-subnet2"
  }
}


resource "aws_key_pair" "minikube-keypair" {
  key_name   = "minikube-keypair"
  public_key = var.public_key
}



# Create a security group for Terraform-project
resource "aws_security_group" "minikube-project-sg" {
  name        = "minikube-project-sg"
  description = "sg for minikube-project"
  vpc_id      = aws_vpc.minikube-vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    description = "Allow SSH"
    from_port   = 8000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "minikube-project-sg"
  }
}


resource "aws_internet_gateway" "minikube-gw" {
  vpc_id = aws_vpc.minikube-vpc.id

  tags = {
    Name = "minikube.gw"
  }
}

#Create an EC2 instance
resource "aws_instance" "minikube_instance" {
  ami           = data.aws_ami.most_recent_amazon_linux_ami.id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.minikube-subnet2.id
  vpc_security_group_ids      = [aws_security_group.minikube-project-sg.id]
  associate_public_ip_address = true
  user_data = file("docker-script.sh")
   root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
  key_name = aws_key_pair.minikube-keypair.key_name

  tags = {
    Name = "minikube"
  }
}

data "aws_ami" "most_recent_amazon_linux_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu-eks/k8s_1.29/images/hvm-ssd/ubuntu-jammy-22.04-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}