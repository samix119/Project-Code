#!/bin/bash

if ! ssh -o PasswordAuthentication=no $1 ls > /dev/null
then
	echo "Server not ready for setup, ssh set ?"
	exit 1
fi	

if ! rsync -av --delete parent-puppet/ $1:/etc/puppet/
then
	echo "Cannot extract puppet conf"
	exit 1
fi

cat vm-parent-manifests/data/$1.txt | perl vm-parent-manifests/scripts/gen_vm_resource.pl > vm-parent-manifests/data/$1.pp
if ! scp -r  vm-parent-manifests/data/$1.pp $1:/etc/puppet/modules/openvz/manifests/vm.pp
then
	echo "vm config for puppet could not be found"
	exit 1
fi

ssh $1 puppet apply --debug /etc/puppet/manifests/site.pp 
ssh $1 puppet apply --debug /etc/puppet/manifests/site.pp 
ssh $1 puppet apply --debug /etc/puppet/manifests/site.pp 
