#!/bin/bash
%{ for key in user_keys ~}
if ! /usr/bin/grep -Fxq "${key}" /home/${ssh_user}/.ssh/authorized_keys; then #check if key is in authorized_keys, add it if not
  sudo /bin/echo "${key}" >> /home/${ssh_user}/.ssh/authorized_keys
fi
%{ endfor ~}
sudo hostnamectl set-hostname "${hostname}"
sudo /bin/echo "${hostname}" > /etc/hostname
#install ssm agent for aws ssh 
sudo yum install -y https://s3.ca-central-1.amazonaws.com/amazon-ssm-ca-central-1/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent