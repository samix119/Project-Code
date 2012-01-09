#!/bin/bash

if [ -z $2 ]
then
	echo "number of vms should be a numeric argument"
	exit 1
fi
	
if ! expr $2 + 1 > /dev/null 2> /dev/null
then
	echo "number of vms should be a numeric argument"
	exit 1
fi

if ! ssh -o PasswordAuthentication=no $1 ls > /dev/null
then
	echo "Server not ready for setup, ssh set ?"
	exit 1
fi	

if ! ssh $1 'yum -y update --exclude=*i386'
then
	echo "Cannot run update"
	exit 1
fi

echo "rebooting the server..."
#ssh $1 reboot
echo "sleeping for 60 seconds..."
#sleep 60

while  ! ssh $1 ls 
do
	echo "sleeping for a minute"
	sleep 60
done

if ! ssh $1 'rpm -ivh http://apt.sw.be/redhat/el5/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm'
then
	echo "Cannot install rpmforge"
#	exit 1
fi

if ! ssh $1 'yum -y install puppet'
then
	echo "Cannot install puppet"
	exit 1
fi


if ! rsync -av --delete parent-puppet/ $1:/etc/puppet/
then
	echo "Cannot extract puppet conf"
	exit 1
fi

ssh $1 puppet apply --debug /etc/puppet/manifests/site.pp
ssh $1 puppet apply --debug /etc/puppet/manifests/site.pp
ssh $1 puppet apply --debug /etc/puppet/manifests/site.pp

## reboot to get into openvz kernel
echo "reboot to get into openvz kernel"
#ssh $1 reboot
echo "sleeping for 60 seconds..."
#sleep 60

while  ! ssh $1 ls 
do
	echo "sleeping for a minute"
	sleep 60
done

ssh $1 rm -f /etc/vz/conf/ve-vzsplit.conf-sample
if ! ssh $1 "/usr/sbin/vzsplit -n $2 -f vzsplit"
then
	echo "Cannot run update"
	exit 1
fi

rsync vm-parent-manifests/image/centos-5-x86_64.tar.gz $1:/vz/template/cache/

cat vm-parent-manifests/data/$1.txt | perl vm-parent-manifests/scripts/gen_vm_resource.pl > vm-parent-manifests/data/$1.pp
if ! scp -r  vm-parent-manifests/data/$1.pp $1:/etc/puppet/modules/openvz/manifests/vm.pp
then
	echo "Vm config for puppet could not be found"
	echo "Could not create vms"
	exit 1
fi

ssh $1 puppet apply --debug /etc/puppet/manifests/site.pp
ssh $1 puppet apply --debug /etc/puppet/manifests/site.pp
ssh $1 puppet apply --debug /etc/puppet/manifests/site.pp
