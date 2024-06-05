#bastion server
resource "aws_instance" "Bastion_Server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.bastion_sg_ids
  subnet_id                   = var.bastion_subnet
  key_name                    = var.bastion_key_name
  #associate_public_ip_address = "true"

  user_data = templatefile(
    "../modules/bastion/user_data.sh",
    {
      user_keys = var.user_keys
      ssh_user  = "ec2-user"
      hostname  = "${local.ClientName}-${var.EnvName}-ansible-${local.App}"
    }
  )

#storage device for bastion
  root_block_device {
    volume_size           = "20"
    volume_type           = "gp3"
    delete_on_termination = false
    encrypted             = true
    tags = {
      Name = "${local.ClientName}-${var.EnvName}-aws-Bastion-Root-Block",
      Env  = var.EnvName,
      App  = local.App
    }
  }

  tags = {
    Name = "${local.ClientName}-${var.EnvName}-aws-Bastion",
    Env  = var.EnvName,
    App  = local.App
  }
}

#bastion EIP
/*resource "aws_eip" "Bastion_EIP" {
  vpc = true
  tags = {
    Name = "${local.ClientName}-${var.EnvName}-${local.App}-EIP"
    Env  = var.EnvName,
    App  = local.App
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.Bastion_Server.id
  allocation_id = aws_eip.Bastion_EIP.id
}*/