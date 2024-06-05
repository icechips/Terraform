#web server
resource "aws_instance" "Web_Server" {
  count                       = var.server_count
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.web_sg_ids
  subnet_id                   = local.SubnetID[count.index]
  key_name                    = var.web_key_name

  user_data = templatefile(
    "../modules/web/user_data.sh",
    {
      user_keys = var.user_keys
      ssh_user  = "ec2-user"
      hostname  = "${local.ClientName}-${var.EnvName}-${local.App}-${count.index + 1}"
    }
  )

#storage device for web
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = false
    encrypted             = true
    tags = {
      Name = "${local.ClientName}-${var.EnvName}-${local.App}-${count.index + 1}-Root-Block",
      Env  = var.EnvName,
      App  = local.App
    }
  }

  tags = {
    Name = "${local.ClientName}-${var.EnvName}-${local.App}-${count.index + 1}",
    Env  = var.EnvName,
    App  = local.App
  }
}