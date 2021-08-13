locals {
  ssh_user = "ubuntu"
  key_name = "SSHKeys"
  private_key_path = "~/.ssh/SSHKeys.pem"
}
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = "us-east-2"
}

resource "aws_instance" "myFirstEC2Instance" {
  ami = "ami-0443305dabd4be2bc"
  instance_type = "t2.micro"

  tags = {
    Name = "myFirstEC2Instance"
  }

  provisioner "remote-exec" {
    inline = ["echo 'wait until ssh is ready'"]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("~/.ssh/SSHKeys.pem")
      host = aws_instance.myFirstEC2Instance.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.myFirstEC2Instance.public_ip}, --private-key ${local.private_key_path} nginx.yml"
  }
}