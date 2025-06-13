resource "aws_key_pair" "deployer" {

  key_name = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "allow_ssh" {
  
  name = "${var.PROJECT_K}-sg"
  description = "Allow SSH inbound traffic"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = [0.0.0.0/0]

  }
}


resource "aws_instance" "jenkins" {
  ami                         = "ami-07eb3a4f8ecf6f8f4"
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.PROJECT_K}-jenkins"
  }
}

resource "aws_instance" "ansible" {
  ami                         = "ami-07eb3a4f8ecf6f8f4"
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.PROJECT_K}-ansible"
  }
}

resource "aws_instance" "k8s-master" {
  ami                         = "ami-07eb3a4f8ecf6f8f4"
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.PROJECT_K}-k8s-master"
  }
}

resource "aws_instance" "k8s-worker" {
  ami                         = "ami-07eb3a4f8ecf6f8f4"
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.PROJECT_K}-k8s-worker"
  }
}

