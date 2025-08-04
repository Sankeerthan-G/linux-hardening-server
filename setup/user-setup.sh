#!/bin/bash
#create new user 
  

USERNAME="sandev"
sudo adduser $USERNAME
sudo usermod -aG sudo $USERNAME






#Disable root SSH Login


sudo sed -i 's/^#PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config

sudo systemctl restart ssh
