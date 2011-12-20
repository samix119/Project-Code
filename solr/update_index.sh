#!/bin/bash
PATH=$PATH:/usr/lib64/qt-3.3/bin:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

filename=`perl /opt/scripts/crunch_logs.pl`
curl http://mis.email360api.com:8983/solr/update/csv  --data-binary @$filename -H 'Content-type:text/plain;charset=utf-8' > /dev/null 2> /dev/null
if [ $? -eq 0 ]
then
	rm $filename
else
	[ -d /var/solr/index ] || mkdir -p /var/solr/index ]
	mv $filename /var/solr/index/
fi


