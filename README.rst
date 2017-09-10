docker-irixinstall
==================

A docker image with support for installing SGI systems from the net with IRIX.

Debian Stretch-slim is used as parent image for the container. The container
will be about 150Mb big. Alternatively, Ubuntu 16.04 will also work.

Build
=====

Build the docker container from the image with:

docker build -t irix-install .

Run
===

First make a copy of the bootptab and change the MAC-adress of the SGI system
and the server (sa) and download (ds) ip address:

cp ./bootptab ~
vi $HOME/bootptab

The example bootptab looks like this:
iris:ha=080069c0ffee:sa=192.168.0.1:ds=192.168.0.1:rp=/DIST

If we assume the dist directory to be at $HOME/dist then the docker run
command should be::

  docker run --sysctl net.ipv4.ip_local_port_range="2048 32767" \
           --sysctl net.ipv4.ip_no_pmtu_disc=1 \
           --network host \
           --add-host iris:192.168.0.2 \
           --volume $HOME/dist:/DIST:ro \
           --volume $HOME/bootptab:/etc/bootptab \
           -P \
           -it irix-install

Make sure that the ip address of the SGI system is set to the same address as
in the line '--add-host' and that it is in the same subnet as the machine where
the docker container runs.

When the container is running, set the 'netaddr' environment variable to the
'iris' ip in the PROM firmware of the SGI system and enter 'init'.
The system will reset and display the PROM menu.

Press '2' for 'Install System Software', select 'Remote Directory'.
For 'remote host' enter the hostname of the machine the docker runs on
For 'remote directory' enter the subdirectory from the $HOME/dist base where
the stand-alone shell (sa) is located.

Volume configuration files
==========================

bootptab
bootps
tftp
rsh

(Only bootptab needs to be changed)

Volume directory
================

/DIST

(location of the IRIX inst packages)
