data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "amzn2-ami-hvm*"
}

resource "aws_instance" "linux_host" {
  
  ami                    = data.aws_ami.amazon-linux-2.id
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  // iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.linux_host_sg.id, var.security_group_id ]// [aws_security_group.linux_host_sg.id]
  tags = {
    Name = "${var.environment}-linux-host"
  }
  user_data = file("${path.module}/install-nginx.sh")

  key_name = var.key_name
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "linux_host_sg" {
  name        = "${var.environment}-linux_host_sg"
  description = "Allow all traffic from VPCs inbound and all outbound"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allow_src_cidr, data.aws_vpc.selected.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssm_host_sg"
  }
}