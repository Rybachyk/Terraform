provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_security_group" "example_sg" {
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example_ec2_1" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "your-key-pair-name"
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  user_data = <<-EOF
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo systemctl start docker
    sudo systemctl enable docker

    sudo docker run -d -p 9100:9100 --name=node-exporter prom/node-exporter
    sudo docker run -d -p 8080:8080 --name=cadvizor-exporter wrouesnel/cadvizor
  EOF
}

resource "aws_instance" "example_ec2_2" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "your-key-pair-name"
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  user_data = <<-EOF
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo systemctl start docker
    sudo systemctl enable docker

    sudo docker run -d -p 9100:9100 --name=node-exporter prom/node-exporter
    sudo docker run -d -p 8080:8080 --name=cadvizor-exporter wrouesnel/cadvizor
  EOF
}
