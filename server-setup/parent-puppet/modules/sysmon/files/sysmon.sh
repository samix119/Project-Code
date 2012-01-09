#!/bin/bash

OUTDIR=/home/sysmon/`date +%d-%m-%Y`
mkdir -p $OUTDIR
srcdir=/home/sysmon/
KEEP_BACKUP_DAYS=30

top -b -c -n 1 > $OUTDIR/`date +%H-%M`.top
ps fauxww > $OUTDIR/`date +%H-%M`.ps
cat /proc/meminfo > $OUTDIR/`date +%H-%M`.meminfo
iostat -dxx 3 5 > $OUTDIR/`date +%H-%M`.iostat
#find $srcdir -type d  -mtime +$KEEP_BACKUP_DAYS -exec rm -fr '{}' ';'
