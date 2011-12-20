#!/bin/bash
PATH=$PATH:/usr/lib64/qt-3.3/bin:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
LOCKFILE=/var/run/reaper.pid
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    exit
fi

trap "[ -e ${LOCKFILE} ] && rm ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

for i in `find /var/solr/index`
do
	if [ -f $i ]
	then
		if curl http://mis.email360api.com:8983/solr/update/csv  --data-binary @$i -H 'Content-type:text/plain;charset=utf-8' > /dev/null 2> /dev/null
		then
			rm $i
		fi
	fi
done

after_count=`find /var/solr/index | wc -l`
echo "after count is $after_count" >> /tmp/log

if [ $after_count -gt 6 ]
then
	echo "after count is $after_count" >> /tmp/log
	if [ ! -e /tmp/indexmailsent ]
	then 
		echo "sending email " >> /tmp/log
		echo "`hostname` has $after_count index files to send" | mail -s "`/bin/hostname` index problem" sysad@madinix.com
		touch /tmp/indexmailsent
	else 
		if test `find /tmp/indexmailsent -mmin +60`
		then
			echo "not sending email as file is 60 mins old" >> /tmp/log
			echo "`hostname` has $after_count index files to send" | mail -s "`/bin/hostname` index problem" sysad@madinix.com
			touch /tmp/indexmailsent
		fi
	fi
fi

rm  ${LOCKFILE}
