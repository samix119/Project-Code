#!/bin/bash

parentname=$1
vmid=$2
hostname=$3

user='sysad'
port='22'

if [ $parentname == "parent31.email360api.com" ]
then
	user='hauntu'
	port='240'
fi

echo "[root@$hostname]# /etc/init.d/dkim stop" > /tmp/$$
ssh $user@$parentname -p $port sudo /usr/sbin/vzctl exec2 $vmid /etc/init.d/dkimproxy stop >> /dev/null 2>> /dev/null
retval=$?
if [ $retval -eq 0 ]
then
	echo "stoping dkim	[OK]" >> /tmp/$$
else
	echo "stoping dkim	[FAILED]" >> /tmp/$$
fi
cat /tmp/$$
rm /tmp/$$
exit $retval
