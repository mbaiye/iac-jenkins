resource "aws_instance" "jenkins_master" {
  ami                    = "ami-00d8fdc07e335e69f"
  instance_type          = "t2.large"
  key_name               = aws_key_pair.mobann-aws-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_master_sg.id]
  subnet_id              = element(aws_subnet.private_subnets, 0).id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = false
  }
  tags = {
    Name = "jenkins_master"
  }
}



resource "aws_security_group" "jenkins_master_sg" {
  name        = "jenkins_master_sg"
  description = "Allow traffic on port 8080 and enable SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port       = "8080"
    to_port         = "8080"
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_master_sg"
  }
}