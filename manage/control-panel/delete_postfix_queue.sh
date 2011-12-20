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

echo "[root@$hostname]# postsuper -d ALL" > /tmp/$$
echo "..output truncated.." > /tmp/$$
ssh $user@$parentname -p $port sudo /usr/sbin/vzctl exec2 $vmid postsuper -d ALL | tail -n 5  >> /tmp/$$ 2>> /tmp/$$
retval=$?
echo "[root@$hostname]# tail -n 10 /var/log/maillog" >> /tmp/$$
ssh $user@$parentname -p $port sudo /usr/sbin/vzctl exec2 $vmid tail -10 /var/log/maillog >> /tmp/$$ 2>> /tmp/$$
cat /tmp/$$
rm /tmp/$$
exit $retval
