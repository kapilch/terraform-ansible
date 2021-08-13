provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = "us-east-2"
}

resource "aws_instance" "myFirstEC2Instance" {
  ami = "ami-0443305dabd4be2bc"
  #ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  #subnet_id = aws_subnet.myFirstSubnet.id

  tags = {
    Name = "myFirstEC2Instance"
  }
  # count = 2

  provisinor "remote-exec" {
    inline = ["echo 'wait until ssh is ready'"]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("./ssh/ssh-aws")
      host = aws_instance.myFirstEC2Instance.public_ip
    }
  }

  provisinor "local-exec" {
    command = "ansible"
  }
}