#!/bin/bash

# description : Install  glusterfs-server, authorize the script with chmod +x install.sh， 
# run : sh install.sh  glusterd

VOLUME_DIR=/gluster-volumes

ser=`/usr/bin/pgrep $1`
if [ "$ser" != "" ];then
   echo "The $1 service is running."
   exit 0
else
   echo "The $1 service is NOT running."
   # Determine whether the service glusterd exists:
   if [  `which  glusterd | wc -l` -ne 0 ]; then
      echo 'glusterd exist, start service--------->'
      /sbin/service $1 start
      exit 0
   else
      echo 'glusterd does not exist, begin to install------->'
   fi
fi
add-apt-repository ppa:gluster/glusterfs-10 -y
if [ $? -ne 0 ]; then
   echo "add-apt-repository ppa:gluster/glusterfs-10 , failed!"
   exit 1
else
   echo "add-apt-repository ppa:gluster/glusterfs-10 , success!"
fi
apt update

apt install -y glusterfs-server glusterfs-client
if [ $? -ne 0 ]; then
   echo "apt install -y glusterfs-server glusterfs-client , failed!"
   exit 1
else
   echo "apt install -y glusterfs-server glusterfs-client, success!"
fi

# start glusterFS
systemctl start glusterd.service
if [ $? -ne 0 ]; then
   echo "systemctl start glusterd.service , failed!"
   exit 1
else
   echo "systemctl start glusterd.service, success!"
fi

systemctl enable glusterd.service
if [ $? -ne 0 ]; then
   echo "systemctl enable glusterd.service, failed!"
   exit 1
else
   echo "systemctl enable glusterd.service, success!"
fi

mkdir $VOLUME_DIR
if [ $? -ne 0 ]; then
   echo "mkdir $VOLUME_DIR, failed!"
   exit 1
else
   echo "mkdir $VOLUME_DIR, success!"
fi