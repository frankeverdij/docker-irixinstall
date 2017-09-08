docker-irixinstall
==================

A docker image with support for installing sgi systems from the net with IRIX
Use the docker run command as such:

docker run --sysctl net.ipv4.ip_local_port_range="2048 32767" -it irix-install

Configuration files
===================

bootptab
bootps
tftp
rsh
