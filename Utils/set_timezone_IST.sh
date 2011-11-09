#!/bin/bash

if [ -e /usr/share/zoneinfo/Asia/Calcutta ]
then
       rm -f /etc/localtime
       ln -s /usr/share/zoneinfo/Asia/Calcutta /etc/localtime
       ntpdate 0.us.pool.ntp.org
else
       echo "Cannot set timezone, as IST timezone does not exist"
       exit 1
fi

