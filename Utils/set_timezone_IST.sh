#!/bin/bash

if [ -e /usr/share/zoneinfo/Asia/Calcutta ]
then
        mv /etc/localtime /etc/localtime.orig
	if ! ln -s /usr/share/zoneinfo/Asia/Calcutta /etc/localtime
	then
		mv /etc/localtime.orig /etc/localtime
	fi
        ntpdate 0.us.pool.ntp.org
else
       echo "Cannot set timezone, as IST timezone does not exist"
       exit 1
fi

