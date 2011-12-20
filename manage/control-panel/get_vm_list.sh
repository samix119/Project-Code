#!/bin/bash

parentname=$1


user='sysad'
port='22'

if [ $parentname == "parent31.email360api.com" ]
then
	user='hauntu'
	port='240'
fi

ssh $user@$parentname -p $port sudo /usr/sbin/vzlist -a -H -o hostname,ip,status,ctid
