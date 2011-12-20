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

echo "[root@$hostname]# postfix stop" > /tmp/$$
ssh $user@$parentname -p $port sudo /usr/sbin/vzctl exec2 $vmid postfix stop >> /tmp/$$ 2>> /tmp/$$
echo "[root@$hostname]# postfix start" >> /tmp/$$
ssh $user@$parentname -p $port sudo /usr/sbin/vzctl exec2 $vmid postfix start >> /tmp/$$ 2>> /tmp/$$
retval=$?
echo "[root@$hostname]# tail -n 10 /var/log/maillog" >> /tmp/$$
ssh $user@$parentname -p $port sudo /usr/sbin/vzctl exec2 $vmid tail -10 /var/log/maillog >> /tmp/$$ 2>> /tmp/$$
cat /tmp/$$
rm /tmp/$$
exit $retval
