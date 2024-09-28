// Website to find ami id: https://cloud-images.ubuntu.com/locator/ec2/ (Note: Should find ami id with arch is amd64)

resource "aws_instance" "web" {
  //AMI_EC2_ID = "ami-03fa85deedfcac80b"
  //AMI_NGINX_ID = "ami-0b5bb2f658163cdf8"
  ami                         = "ami-0b5bb2f658163cdf8"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.public_http_traffic.id]
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  tags = merge(local.common_tags, {
    Name = "resources-ec2"
  })

  lifecycle {
    create_before_destroy = true //default destroy_before_create = true
  }
}

resource "aws_security_group" "public_http_traffic" {
  description = "Security group for open only port 80 and port 443"
  name        = "public_http_traffic"
  vpc_id      = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "resources-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80

  tags = merge(local.common_tags, {
    Name = "resources-sg-http-rule"
  })
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443

  tags = merge(local.common_tags, {
    Name = "resources-sg-https-rule"
  })
}