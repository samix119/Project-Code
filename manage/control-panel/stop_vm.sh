#!/bin/bash

parentname=$1
vmid=$2
hostname=$3
p_hostname=$4

user='sysad'
port='22'

if [ $parentname == "parent31.email360api.com" ]
then
	user='hauntu'
	port='240'
fi

echo "[root@$p_hostname]# vzctl stop $vmid" > /tmp/$$
ssh $user@$parentname -p $port sudo /usr/sbin/vzctl stop $vmid >> /tmp/$$ 2>> /tmp/$$
retval=$?
#echo "[root@$p_hostname]#" >> /tmp/$$
cat /tmp/$$
rm /tmp/$$
exit $retval
