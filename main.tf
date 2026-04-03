resource "aws_key_pair" "deployer" {
  key_name   = "terra-key"
  public_key = file("terra-key.pub")
}


resource "aws_vpc" "terra" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terra"
  }
}
resource "aws_subnet" "terra_subnet" {
  vpc_id     = aws_vpc.terra.id  
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.terra.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
   
  }
  tags = {
    Name = "terra-auto-sg"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terra.id

  tags = {
    Name = "terra-igw"
  }
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.terra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "terra-rt"
  }
}
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.terra_subnet.id
  route_table_id = aws_route_table.rt.id
}


resource "aws_instance" "my_ec2" {
  ami           = var.ami_id   # Ubuntu (Mumbai)
  instance_type = var.instance_type
  key_name      = "terra-key"   # must already exist

  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  subnet_id = aws_subnet.terra_subnet.id

  # Install Docker and Nginx via cloud-init
  user_data = file("setup_instance.sh")

  tags = {
    Name = "Terraform-EC2"
  }
}
