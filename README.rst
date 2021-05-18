docker-irixinstall
==================

A docker image with support for installing SGI systems from the net with IRIX.

Debian Buster-slim is used as parent image for the container. The container
will be about 150Mb big.

Build
=====

Build the docker container from the image with::

  docker build -t irix-install .

Configure
=========

First, edit the bootptab::

  vi bootptab

Then change the MAC-adress of the SGI system and both ip addresses of the
tftp server (sa) and domain server (ds) in the bootptab file.

The example bootptab looks like this::

  iris:ha=080069c0ffee:sa=192.168.0.1:ds=192.168.0.1:rp=/DIST

This bootptab will answer to the SGI system with MAC address 08:00:69:c0:ff:ee
and returns the tftp/domain server address 192.168.0.1

Run
===

Next we execute the docker run command in the directory where the bootptab,
bootps, tftp and rsh configuration files are. If we assume the dist directory to be
at $HOME/dist then the docker run command should be::

  docker run --sysctl net.ipv4.ip_local_port_range="2048 32767" \
             --sysctl net.ipv4.ip_no_pmtu_disc=1 \
             --network host \
             --add-host iris:192.168.0.2 \
             --volume $HOME/dist:/DIST:ro \
             -P \
             -it irix-install

Make sure that the ip address of the SGI system in the PROM is set to the same
address as in the line '--add-host' and that it is in the same subnet as the
server where the docker container runs.

Recent docker version complain and exit about setting the two kernel parameters.
A workaround is to set them on the server where the docker runs, like::

  sudo sysctl -w net.ipv4.ip_local_port_range="2048 32767"
  sudo sysctl -w net.ipv4.ip_no_pmtu_disc=1


Configure SGI system
====================

When the container is running, set the 'netaddr' environment variable to the
'iris' ip in the PROM firmware of the SGI system::

  setenv -p netaddr 192.168.0.2

followed by entering 'init'.The system will reset and display the PROM menu.
If it tries to boot from disk, hit <esc> and it will enter the menu.

Press '2' for 'Install System Software', select 'Remote Directory'.
For 'remote host' enter the hostname of the install server where the docker
runs.
For 'remote directory' enter the subdirectory from the $HOME/dist base where
the stand-alone shell (sa) is located.

If the stand-alone shell is located on the install server at
'$HOME/dist/irix6522A/dist/sa', then enter '/irix6522A/dist'

If you get ARP warnings about not being able to resolve the server, try adding
a 'srvaddr' variable to the PROM environment::

  setenv -p srvaddr 192.168.0.1

and enter 'init'. Redo the installation steps in the PROM menu.

Volume configuration files
==========================

 ::

  bootptab  : lists for each hostname the MAC, tftp and domain server addresses
  bootps    : bootp daemon configuration file
  tftp      : trivial ftp configuration file
  rsh       : remote shell configuration file

(Only bootptab needs to be changed)

Volume directory
================

 ::

  /DIST    : root location of the IRIX inst packages, stand-alone, fx and ide images
  

