#!/bin/bash
# $1 = MailServer's Domain-Name or IP Address
# $2 = Email Address or Domain-Name or KeyWord To Find
# $3 = Options for Today [1], Yesterday [2], Current Week [3], Last Week [4]
# Truncating the output file
> /var/www/html/LOG-Interface/Maillog-Interface-final.out

DAY=`date +%d`
DAY_CHOPPED=`date +%d | cut -c 2`
YDAY=`expr $DAY - 1`
YDAY_CHOPPED=`expr $DAY_CHOPPED - 1`
MONTH=`date +%m`
if [ $MONTH = 01 ] ; then
        MTH=Jan
elif [ $MONTH = 02 ] ; then
        MTH=Feb
elif [ $MONTH = 03 ] ; then
        MTH=Mar
elif [ $MONTH = 04 ] ; then
        MTH=Apr
elif [ $MONTH = 05 ] ; then
        MTH=May
elif [ $MONTH = 06 ] ; then
        MTH=Jun
elif [ $MONTH = 07 ] ; then
        MTH=Jul
elif [ $MONTH = 08 ] ; then
        MTH=Aug
elif [ $MONTH = 09 ] ; then
        MTH=Sep
elif [ $MONTH = 10 ] ; then
        MTH=Oct
elif [ $MONTH = 11 ] ; then
        MTH=Nov
elif [ $MONTH = 12 ] ; then
        MTH=Dec
else
echo > /dev/null
fi

if [ "$DAY" -eq 01 ] || [ "$DAY" -eq 02 ] || [ "$DAY" -eq 03 ] || [ "$DAY" -eq 04 ] || [ "$DAY" -eq 05 ] || [ "$DAY" -eq 06 ] || [ "$DAY" -eq 07 ] || [ "$DAY" -eq 08 ] || [ "$DAY" -eq 09 ]
        then
case $3 in
#1) sudo ssh $1 "/bin/grep '$MTH  $DAY_CHOPPED' /var/log/maillog | /bin/grep $2 | /bin/grep -v relay=127.0.0.1 > /tmp/Maillog-Interface.out" ; sudo scp $1:/tmp/Maillog-Interface.out /var/www/html/LOG-Interface/Maillog-Interface-final.out ;;
1) sudo ssh $1 "/bin/grep '$MTH  $DAY_CHOPPED' /var/log/maillog | /bin/grep $2 | /bin/egrep -v 'relay=127.0.0.1|warning: header Subject:' > /tmp/Maillog-Interface.out" ; sudo scp $1:/tmp/Maillog-Interface.out /var/www/html/LOG-Interface/Maillog-Interface-final.out ;;
2) sudo ssh $1 "/bin/grep '$MTH  $YDAY_CHOPPED' /var/log/maillog | /bin/grep $2 | /bin/egrep -v 'relay=127.0.0.1|warning: header Subject:' > /tmp/Maillog-Interface.out" ; sudo scp $1:/tmp/Maillog-Interface.out /var/www/html/LOG-Interface/Maillog-Interface-final.out ;;
3) sudo ssh $1 "/bin/grep $2 /var/log/maillog | /bin/egrep -v 'relay=127.0.0.1|warning: header Subject:' > /tmp/Maillog-Interface.out" ; sudo scp $1:/tmp/Maillog-Interface.out /var/www/html/LOG-Interface/Maillog-Interface-final.out ;;
4) sudo ssh $1 "/usr/bin/zgrep $2 /var/log/maillog.1.gz | /usr/bin/zegrep -v 'relay=127.0.0.1|warning: header Subject:' > /tmp/Maillog-Interface.out" ; sudo scp $1:/tmp/Maillog-Interface.out /var/www/html/LOG-Interface/Maillog-Interface-final.out ;;
*) exit
esac
        else
case $3 in
#1) sudo ssh $1 "/bin/grep '$MTH $DAY' /var/log/maillog | /bin/grep $2 | /bin/grep -v relay=127.0.0.1 > /tmp/Maillog-Interface.out" ; sudo scp $1:/tmp/Maillog-Interface.out /var/www/html/LOG-Interface/Maillog-Interface-final.out ;;
1) sudo ssh $1 "/bin/grep '$MTH $DAY' /var/log/maillog | /bin/grep $2 | /bin/egrep -v 'relay=127.0.0.1|warning: header Subject:' > /tmp/Maillog-Interface.out" ; sudo scp $1:/tmp/Maillog-Interface.out /var/www/html/LOG-Interface/Maillog-Interface-final.out ;;
2) sudo ssh $1 "/bin/grep '$MTH $YDAY' /var/log/maillog | /bin/grep $2 | /bin/egrep -v 'relay=127.0.0.1|warning: header Subject:' > /tmp/Maillog-Interface.out" ; sudo scp $1:/tmp/Maillog-Interface.out /var/www/html/LOG-Interface/Maillog-Interface-final.out ;;
3) sudo ssh $1 "/bin/grep $2 /var/log/maillog | /bin/egrep -v 'relay=127.0.0.1|warning: header Subject:' > /tmp/Maillog-Interface.out" ; sudo scp $1:/tmp/Maillog-Interface.out /var/www/html/LOG-Interface/Maillog-Interface-final.out ;;
4) sudo ssh $1 "/usr/bin/zgrep $2 /var/log/maillog.1.gz | /usr/bin/zegrep -v 'relay=127.0.0.1|warning: header Subject:' > /tmp/Maillog-Interface.out" ; sudo scp $1:/tmp/Maillog-Interface.out /var/www/html/LOG-Interface/Maillog-Interface-final.out ;;
*) exit
esac
fi

#echo
#cat /var/www/html/LOG-Interface/Maillog-Interface-final.out
#echo

#
###############################################################
###############################################################
#
#
#/bin/cat /var/log/maillog | egrep "$MTH $DAY" | head
#/bin/cat /var/log/maillog | grep "$MTH $DAY" | grep NOkiacoding
#
######################## The below code is to grep for yesterday's maillog's too.
#WhichDay=$1
#echo $WhichDay > /root/WhichDay
#if [ $WhichDay = 1 ] ; then
#       /bin/cat /var/log/maillog | grep "$MTH $DAY" | grep http | egrep -v '\ 4..\ ' | awk -F 'http://' '{ print $2 }' | awk '{ print $1 }' | sort | uniq
#elif [ $WhichDay = 2 ] ; then
#       /bin/cat /var/log/maillog | grep "$MTH $YDAY" | grep http | egrep -v '\ 4..\ ' | awk -F 'http://' '{ print $2 }' | awk '{ print $1 }' | sort | uniq
#else
#echo > /dev/null
#fi

