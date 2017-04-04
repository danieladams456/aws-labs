#!/bin/bash
#systemd service changes have to be before the upgrade command
#is invoked or they will be lost on reboot
systemctl disable docker
systemctl enable docker-latest
sed -i '/DOCKERBINARY/s/^#//g' /etc/sysconfig/docker
atomic host upgrade
